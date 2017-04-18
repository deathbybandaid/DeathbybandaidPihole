#!/bin/sh
## NTP
{ if (whiptail --yesno "Do you want to set ntp servers? serverlist is available at http://support.ntp.org/bin/view/Servers/NTPPoolServers" 8 78) then
NEW_NTP=$(whiptail --inputbox "Set server here" 20 60 "debian.pool.ntp.org" 3>&1 1>&2 2>&3)
sudo cp /etc/ntp.conf /etc/piadvanced/backups/
sudo sed -i "s/pool 0.debian.pool.ntp.org iburst/pool 0.$NEW_NTP iburst/" /etc/ntp.conf
sudo sed -i "s/pool 1.debian.pool.ntp.org iburst/pool 1.$NEW_NTP iburst/" /etc/ntp.conf
sudo sed -i "s/pool 2.debian.pool.ntp.org iburst/pool 2.$NEW_NTP iburst/" /etc/ntp.conf
sudo sed -i "s/pool 3.debian.pool.ntp.org iburst/pool 3.$NEW_NTP iburst/" /etc/ntp.conf
sudo service ntp stop
sudo ntpd -gq
sudo service ntp start
else
echo ""
fi }

## NTP Script
{ if (whiptail --yesno "Do you want to set a script to refresh time?" 8 78) then
sudo echo "sudo service ntp stop" | sudo tee --append /etc/piadvanced/installscripts/ntpupdate.sh
sudo echo "sudo ntpd -gq
sudo service n" | sudo tee --append /etc/piadvanced/installscripts/ntpupdate.sh
sudo echo "sudo service ntp start" | sudo tee --append /etc/piadvanced/installscripts/ntpupdate.sh
(crontab -l ; echo "0,30 * * * * sudo bash /etc/piadvanced/installscripts/ntpupdate.sh") | crontab -
else
echo ""
fi }