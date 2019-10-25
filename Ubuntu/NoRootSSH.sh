#!/bin/bash
#PermitRootLogin no 


su 
nano etc/ssh/sshd_config
systemctl restart sshd
service sshd restart
/etc/init.d/ssh restart