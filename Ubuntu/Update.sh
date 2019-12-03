#!/bin/bash
# A simple script that updates and upgrades the system
# The script also disables IPv6 and installs/enables UFW firewall
apt-get update
apt-get upgrade
apt-get autoremove
apt-get autoclean

apt-install ufw
