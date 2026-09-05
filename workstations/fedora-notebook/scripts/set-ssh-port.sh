#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root (use sudo)."
    exit 1
fi

show_port() {
	grep -E "^#?Port " /etc/ssh/sshd_config | awk '{print $2}'
}

change_port() {
	local port
	local newport

	port=$(show_port)

	echo "Current Port: $port"
	read -p "Enter the new port: " newport

	if [[ -z "$newport" || ! "$newport" =~ ^[0-9]+$ ]]; then
		echo "Error: Invalid port number."
		return 1
	fi

	sed -i "s/^#\?Port $port/Port $newport/" /etc/ssh/sshd_config

	mkdir -p /etc/systemd/system/sshd.socket.d/

	echo -e "[Socket]\nListenStream=\nListenStream=$newport" > /etc/systemd/system/sshd.socket.d/override.conf

	semanage port -a -t ssh_port_t -p tcp "$newport" 2>/dev/null || \
	semanage port -m -t ssh_port_t -p tcp "$newport"

	firewall-cmd --zone=public --add-port="${newport}/tcp" --permanent >/dev/null
	if [ -n "$port" ] && [ "$port" != "$newport" ]; then
		firewall-cmd --zone=public --remove-port="${port}/tcp" --permanent 2>/dev/null
	fi
	firewall-cmd --reload >/dev/null
	
	systemctl daemon-reload
	systemctl enable sshd.socket
	systemctl restart sshd.socket
}

while true; do
	clear

	echo "================================"
	echo "=======Choose your option======="
	echo "================================"
	echo "(1) Show current SSH port."
	echo "(2) Change SSH port."
	echo "(0) Exit."
	echo "================================"

	read -p "Enter the number: " option

	case "$option" in
		1)
			show_port
			;;
		2)
			change_port
			;;
		0)
			exit 0
			;;
		*)
			echo "Invalid option."
			;;
	esac

	echo "================================"
	read -p "Press ENTER to continue..."
done
