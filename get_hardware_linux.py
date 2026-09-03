#!/usr/bin/env python3
import os
import platform
import subprocess

def get_sys_info():
    print("==========================================")
    print("    SYSTEM HARDWARE TELEMETRY (LINUX)     ")
    print("==========================================")
    print(f"Hostname     : {platform.node()}")
    print(f"Kernel       : {platform.release()}")
    print(f"Architecture : {platform.machine()}")

def get_cpu_info():
    print("\n[CPU Information]")
    try:
        cmd = "lscpu | grep -E 'Model name|Socket|Thread|NUMA|CPU\\(s\\):'"
        output = subprocess.check_output(cmd, shell=True, text=True)
        for line in output.strip().split('\n'):
            print(f" {line.strip()}")
    except Exception as e:
        print(f" Error reading CPU info: {e}")

def get_ram_info():
    print("\n[Memory Information (RAM)]")
    try:
        with open('/proc/meminfo', 'r') as f:
            lines = f.readlines()
            mem_data = {}
            for line in lines:
                parts = line.split(':')
                if len(parts) == 2:
                    mem_data[parts[0].strip()] = parts[1].strip()

            total = int(mem_data.get('MemTotal', '0 kB').split()[0]) / 1024 /1024
            free = int(mem_data.get('MemAvailable', '0 kB').split()[0]) / 1024 /1024
            used = total -free

            print(f" Total RAM: {total:.2f} GB")
            print(f" Used RAM : {used:.2f} GB")
            print(f" Free RAM : {free:.2f} GB")
    except Exception as e:
        print(f" Error reading Memory info: {e}")

def get_storage_info():
    print("\n[Storage / Mount Points]")
    try:
        output = subprocess.check_output("df -h -T -x tmpfs -x devtmpfs -x squashfs", shell=True, text=True)
        print(output.strip())
    except Exception as e:
        print(f" Error reading Storage info: {e}")

def get_network_info():
    print("\n[Network Interfaces & IPs]")
    try:
        output = subprocess.check_output("ip -4 -brief addr", shell=True, text=True)
        print(output.strip())
    except Exception as e:
        print(f" Error reading Network info: {e}")

def main():
    get_sys_info()
    get_cpu_info()
    get_ram_info()
    get_storage_info()
    get_network_info()
    print("==========================================")

if __name__ == "__main__":
    main()

