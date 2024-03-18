#Libary import
import os
import subprocess
from ftplib import FTP

def log_connected_ips():
    # Obtaining IP adresses
    connected_ips = subprocess.check_output("arp -n | grep -v incomplete | awk '{print $1}'", shell=True).decode().split("\n")

    # Logging IPs
    with open('/tmp/network_activity.log', 'a') as log_file:
        for ip in connected_ips:
            activity = subprocess.check_output(f"ping -c 1 {ip} 2>&1", shell=True).decode()
            log_file.write(f"{ip} - {activity}\n")

def upload_to_ftp():
    ftp = FTP('ftp.priklad.com') #Change before using
    ftp.login(user='username', passwd='example123') #Change this line as well
    with open('/tmp/network_activity.log', 'rb') as log_file:
        ftp.storbinary(f"STOR /path/to/remote/network_activity.log", log_file)
    ftp.quit()

# Re-running script every 5 minutes
while True:
    log_connected_ips()
    upload_to_ftp()
    time.sleep(300)  # 300 seconds (5 minutes)
