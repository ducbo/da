#!/bin/sh

OS=`uname`;
STT_VER=""
VERSION_CENTOS=""
TRUE_FALSE="n"

echo "##################################################"
echo "#            + CENTOS   6 64BIT (1)              #"
echo "#            + CENTOS   7 64BIT (2)              #"
echo "#            + FREEBSD  9 64BIT (3)              #"
echo "#            + FREEBSD 11 64BIT (4)              #"
echo "#            + DEBIAN   7 64BIT (5)              #"
echo "#            + DEBIAN   8 64BIT (6)              #"
echo "#            + DEBIAN   9 64BIT (7)              #"
echo "##################################################"
echo ""

while [ "$TRUE_FALSE" = "n" ];
do
{
	echo "Enter The OS Version Number You"
	echo -n "Want To Install (Ex: 1, 2, 3, 4, 5, 6, 7): "
	read STT_VER;
	echo ""
	if [ "$STT_VER" = "1" ] || [ "$STT_VER" = "2" ] || [ "$STT_VER" = "3" ] || [ "$STT_VER" = "4" ] || [ "$STT_VER" = "5" ] || [ "$STT_VER" = "6" ] || [ "$STT_VER" = "7" ]; then
		echo "Ok"
		TRUE_FALSE="y";
		sleep 3;
		clear
	else
		echo "Sorry, this OS is not supported by FPT.OVH"
		TRUE_FALSE="n";
		sleep 3;
		clear
	fi
}
done;

if [ "$STT_VER" = "1" ]; then
	VERSION_CENTOS=6
elif [ "$STT_VER" = "2" ]; then
	VERSION_CENTOS=7	
elif [ "$STT_VER" = "3" ]; then
	VERSION_CENTOS=009
elif [ "$STT_VER" = "4" ]; then
	VERSION_CENTOS=111
elif [ "$STT_VER" = "5" ]; then
	VERSION_CENTOS=07
elif [ "$STT_VER" = "6" ]; then
	VERSION_CENTOS=08
elif [ "$STT_VER" = "7" ]; then
	VERSION_CENTOS=09
fi

cd /root
wget -O /root/centos${VERSION_CENTOS}.sh ${SERVER}/files/centos${VERSION_CENTOS}.sh
chmod 777 /root/centos${VERSION_CENTOS}.sh
echo "Performing DirectAdmin Installation..."
sleep 5;
./centos${VERSION_CENTOS}.sh
sleep 5;

if [ ! -s /usr/local/directadmin/conf/directadmin.conf ]; then
	echo "Error Installing Directadmin. Please Try Rebuild OS Then Install."
	exit 0;
fi

	rm -rf /var/www/html/index.html
	rm -rf /root/centos${VERSION_CENTOS}.sh
	echo "<title>FPT.OVH - Directadmin nulled</title>" >> /var/www/html/index.html
	echo "Buy license at <a href="https://fpt.ovh">here</a></br>" >> /var/www/html/index.html
	wget -O /usr/local/directadmin/data/admin/update.sh http://fpt.ovh/files/update.sh
	echo "rm -rf /usr/local/directadmin/data/admin/brute_log_entries.list" >> /usr/local/directadmin/data/admin/delete-log.sh
	echo "rm -rf /usr/local/directadmin/data/admin/brute_user.data" >> /usr/local/directadmin/data/admin/delete-log.sh
	echo "rm -rf /usr/local/directadmin/data/admin/brute_ip.data" >> /usr/local/directadmin/data/admin/delete-log.sh
	chmod +x /usr/local/directadmin/data/admin/update.sh
	chmod +x /usr/local/directadmin/data/admin/delete-log.sh
	echo "0 0 * * * root /usr/local/directadmin/data/admin/delete-log.sh" >> /etc/cron.d/directadmin_cron
	echo "0 0 * * * root /usr/local/directadmin/data/admin/update.sh" >> /etc/cron.d/directadmin_cron
	service crond restart
	rm -rf /root/setup.sh
	clear

cd /usr/local/directadmin/scripts || exit
SERVERIP=`cat ./setup.txt | grep ip= | cut -d= -f2`;
USERNAME=`cat ./setup.txt | grep adminname= | cut -d= -f2`;
PASSWORD=`cat ./setup.txt | grep adminpass= | cut -d= -f2`;
echo "Directadmin Has Been Installed."
echo "Url Login http://${SERVERIP}:2222"
echo "User Admin: $USERNAME"
echo "Pass Admin: $PASSWORD"
echo "Buy A Lifetime License at https://fpt.ovh"
