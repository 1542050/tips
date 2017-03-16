#!/bin/sh

# -------------------------------------------------------------------
# Headless VirtualBox installation script with PhpVirtualBox
# -------------------------------------------------------------------

# 1. Add VirtualBox source
echo "deb http://download.virtualbox.org/virtualbox/debian precise contrib" > virtualbox.list
sudo mv virtualbox.list /etc/apt/sources.list.d/
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -

# 2. Install VirtualBox
sudo apt-get update
sudo apt-get install -y linux-headers-`uname -r` build-essential virtualbox-4.2 dkms

# 3. Instal VirtualBox extension pack
wget http://dlc.sun.com.edgesuite.net/virtualbox/4.2.4/Oracle_VM_VirtualBox_Extension_Pack-4.2.4-81684.vbox-extpack
sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-4.2.4-81684.vbox-extpack

# 4. Adding a new user named "vbox" with password "pass"
sudo useradd -m vbox -G vboxusers
echo "vbox:pass" | sudo chpasswd

# 5. Update VirtualBox WebServices installation to use the "vbox" user
echo "VBOXWEB_USER=vbox" > virtualbox
sudo mv virtualbox /etc/default/
sudo update-rc.d vboxweb-service defaults
sudo /etc/init.d/vboxweb-service restart

# 6. Install Apache, PHP and other required stuff by PhpVirtualBox
sudo apt-get install -y apache2-mpm-prefork apache2-utils apache2.2-bin apache2.2-common apache2 apache2-doc apache2-suexec libapache2-mod-php5 libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libapr1 php5-common php5-mysql php5-suhosin php-pear wget unzip

# 7. Install PhpVirtualBox
cd /var/www
sudo wget https://phpvirtualbox.googlecode.com/files/phpvirtualbox-4.2-4.zip
sudo unzip -q phpvirtualbox-4.2-4.zip
sudo rm phpvirtualbox-4.2-4.zip
sudo mv phpvirtualbox-4.2-4 phpvirtualbox

# 8. Use default configuration
sudo cp phpvirtualbox/config.php-example phpvirtualbox/config.php

# 9. Let the user know what to do next
IP=`ifconfig eth0 | grep -o 'inet addr:[0-9\.]\+ ' | grep -o '[0-9\.]\+'`
echo "Navigate to http://$IP/phpvirtualbox and login using admin/admin"
echo "Add the line 'var \$consoleHost = \"$IP\";' to /var/www/phpvirtualbox/config.php if you experience null:9000"
