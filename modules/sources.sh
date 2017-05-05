#!/bin/sh
## Sources
NAMEOFAPP="sources"
WHATITDOES="These are various sources for app installation."

## Current User
CURRENTUSER="$(whoami)"

## Dependencies Check
sudo bash /etc/piadvanced/dependencies/dep-whiptail.sh

## Variables
source /etc/piadvanced/install/firewall.conf
source /etc/piadvanced/install/variables.conf
source /etc/piadvanced/install/userchange.conf

{ if 
(whiptail --title "$NAMEOFAPP" --yes-button "Skip" --no-button "Proceed" --yesno "Do you want to setup $NAMEOFAPP? $WHATITDOES" 8 78) 
then
echo "$CURRENTUSER Declined $NAMEOFAPP" | sudo tee --append /etc/piadvanced/install/installationlog.txt
echo ""$NAMEOFAPP"install=no" | sudo tee --append /etc/piadvanced/install/variables.conf
else
echo "$CURRENTUSER Accepted $NAMEOFAPP" | sudo tee --append /etc/piadvanced/install/installationlog.txt
echo ""$NAMEOFAPP"install=yes" | sudo tee --append /etc/piadvanced/install/variables.conf

## Below here is the magic.
whiptail --msgbox "I'm going to add sources ." 10 80 1 
sudo sed -i '/repozytorium.mati75.eu/d' /etc/apt/sources.list
sudo sed -i '/mirrordirector.raspbian.org/d' /etc/apt/sources.list.d/stretch.list
sudo sed -i '/APT::Default-Release "jessie";/d' /etc/apt/apt.conf.d/99-default-release
sudo cp /etc/apt/sources.list /etc/piadvanced/backups/sources/
sudo cp /etc/apt/apt.conf.d/99-default-release /etc/piadvanced/backups/sources/
sudo cp /etc/apt/sources.list.d/stretch.list /etc/piadvanced/backups/sources/
sudo echo 'deb http://repozytorium.mati75.eu/raspbian jessie-backports main contrib non-free' | sudo tee --append /etc/apt/sources.list
sudo echo 'deb http://mirrordirector.raspbian.org/raspbian/ stretch main contrib non-free rpi' | sudo tee --append /etc/apt/sources.list.d/stretch.list
sudo echo 'APT::Default-Release "jessie";' | sudo tee --append /etc/apt/apt.conf.d/99-default-release
sudo gpg --keyserver pgpkeys.mit.edu --recv-key CCD91D6111A06851
sudo gpg --armor --export CCD91D6111A06851 | apt-key add -
sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2C0D3C0F
sudo wget https://archive.raspbian.org/raspbian.public.key -O - | sudo apt-key add -
sudo curl https://bintray.com/user/downloadSubjectPublicKey?username=bintray | sudo apt-key add -
sudo echo "deb https://dl.bintray.com/fg2it/deb jessie main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

## End of install
fi }

## Unset Temporary Variables
unset NAMEOFAPP
unset CURRENTUSER
unset WHATITDOES

## Module Comments
