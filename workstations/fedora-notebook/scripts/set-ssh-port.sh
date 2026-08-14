#!/bin/bash

while true; do
	clear

	echo "================================"
	echo "=======Choose your option======="
	echo "================================"
	echo "(1) Show current SSH port."
	echo "(2) Change SSH port."
	echo "(3) Exit."
	echo "================================"

	read -p "Enter the number: " option

	case "$option" in
		1)
			grep -E "^#?Port " /etc/ssh/sshd_config | awk '{print $2}'
			;;
		2)
			port=$(grep -E "^#?Port " /etc/ssh/sshd_config | awk '{print $2}')
			echo "Current Port: " $port
			read -p "Enter the new port: " newport
			sed -i "s/^#\?Port $port/Port $newport/" /etc/ssh/sshd_config
			mkdir -p /etc/systemd/system/sshd.socket.d/
			echo -e "[Socket]\nListenStream=\nListenStream=$newport" > /etc/systemd/system/sshd.socket.d/override.conf
			semanage port -a -t ssh_port_t -p tcp $newport
			firewall-cmd --zone=public --add-port=$newport/tcp --permanent
			firewall-cmd --zone=public --remove-service=ssh --permanent
			firewall-cmd --reload
			systemctl daemon-reload
			systemctl restart sshd.socket sshd
			systemctl enable sshd.socket
			systemctl enable sshd.service
			;;
		3)
			exit 0
		;;
	esac
	echo "================================"
	read -p "Press ENTER to continue..."
done

