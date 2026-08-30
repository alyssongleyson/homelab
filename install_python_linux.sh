#!/bin/bash

echo "Checking Linux environment..."
if ! command -v python3 &> /dev/null; then
	echo "Python3 not found. Installing..."
	if [ -f /etc/debian_version ]; then
		sudo apt install python3 python3-pip -y
	elif [ -f /etc/redhat-release ]; then
		sudo dnf install python3 python3-pip -y
	fi
fi

