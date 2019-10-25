#!/bin/bash
#Blocks Certian Logins

#Blocks Guest login
sudo sh -c 'printf "[SeatDefaults]\nallow-guest=false\n" > /etc/lightdm/lightdm.conf.d/50-no-guest.conf'

#Blocks Remote login
sudo sh -c 'printf "[SeatDefaults]\ngreeter-show-remote-login=false\n" >/etc/lightdm/lightdm.conf.d/50-no-remote-login.conf'


#Blocks SSH Root Login
# in sshd_config PermitRootLogin no 
 
sudo nano etc/ssh/sshd_config
sudo systemctl restart sshd
sudo service sshd restart
sudo /etc/init.d/ssh restart

#Stops VSFPTD
sudo service VSFPTD stop

