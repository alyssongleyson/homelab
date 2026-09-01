#!/usr/bin/env python3
import os
import platform
import subprocess
import sys

def clear_screen():
    os.system('cls' if platform.system() == 'Windows' else 'clear')

def get_os():
    system = platform.system().lower()
    if system in ['linux', 'darwin']:
        return 'linux'
    elif system == 'windows':
        return 'windows'
    return 'unknown'

def execute_script(script_path, target_os):
    current_os = get_os()

    if target_os != 'any' and current_os != target_os:
        print(f"\n[ERRO] This script is exclusive to systems {target_os.upper()}.")
        print(f"Current operating system: {current_os.upper()}")
        input("\nPress Enter to continue...")
        return

    full_path = os.path.join(os.path.dirname(__file__), script_path)

    if not os.path.exists(full_path):
        print(f"\n[ERRO] Script not found at: {full_path}")
        input("\nPress Enter to continue...")
        return

    print(f"\nRunning: {script_path}\n" + "-"*40)
    try:
        if current_os == 'windows':
            subprocess.run(["powershell.exe", "-ExecutionPolicy", "Bypass", "-File", full_path], check=True)
        else:
            subprocess.run(["bash", full_path], check=True)
    except subprocess.CalledProcessError as e:
        print(f"\n[ERRO] Script execution failed. Exit code: {e.returncode}")
    except Exception as e:
        print(f"\n[ERRO] Failed to start process: {str(e)}")

    input("\nExecution complete. Press Enter to return to the menu...")

def main():
    while True:
        clear_screen()
        current_os = get_os()
        print("==========================================")
        print(f"   HOME LAB MANAGER CLI (OS: {current_os.upper()})")
        print("==========================================")
        print("1. [Any] Check network status")
        print("2. [Linux] Change SSH Port")
        print("0. Exit")
        print("==========================================")

        choice = input("Select an option: ").strip()

        if choice == '1':
            cmd = "ipconfig" if current_os == "windows" else "ip a"
            subprocess.run(cmd, shell=True)
            input("\nPress Enter to continue...")
        elif choice == '2':
            execute_script("workstations/fedora-notebook/scripts/set-ssh-port.sh", target_os="linux")
        elif choice == '0':
            print("\nLeaving...")
            sys.exit(0)
        else:
            input("Invalid option! Press Enter to try again...")

if __name__ == "__main__":
    main()

