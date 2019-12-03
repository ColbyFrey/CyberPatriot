#!/bin/bash
#**Installs and runs clamtk and ufw. Creates virus scan log called 'scanLog', and inserts found viruses into folder 'quarantine', both in folder 'virusScanResults' on user's desktop**#
#Install
sudo apt-get install -y clamtk ufw gufw rkhunter chkrootkit

##clamtk
sudo freshclam
printf "Scanning for viruses under '/home/....."
mkdir /home/$USER/Desktop/virusScanResults/
mkdir /home/$USER/Desktop/virusScanResults/Quarantine/
sudo clamscan -ril /home/$USER/Desktop/virusScanResults/scanLog --bell --move=/home/$USER/Desktop/virusScanResults.txt /home/

##rtkit hunter
sudo chkrootkit
suod rkhunter --update
suod rkhunter --propupd
suod rkhunter --check

#ufw
sudo ufw enable
#Defaults
sudo ufw default deny incoming
sudo ufw default allow outgoing
#SSH
sudo ufw allow 22/tcp
sudo ufw allow ssh
sudo ufw allow sshd
#FTP
sudo ufw allow 21/tcp
sudo ufw allow ftp
#Web
sudo ufw allow www
sudo ufw allow 80/tcp
#Log stuff
sudo ufw logging on

#Big thank to https://wwufww.digitalocean.com/community/tutorials/how-to-setup-a-firewall-with-ufw-on-an-ubuntu-and-debian-cloud-server
