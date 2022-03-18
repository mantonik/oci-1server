#!/bin/bash
# #Script is executed as root user
# 1/16/2022 - add more comments to script. script didn't executed on app2 server 
#   fix if condition
#   remove server_id entry before adding new entry
# #Remvoe MySQL server first if neede d
# dnf remove mysql-server
# rm -rf /var/lib/mysql
# 2/20/2022 - add debug for create repusr



set +x 

LOGFILE=/root/log/mysql.setup.log

##################
# FUNCTION
##################

function update_mysql_root_password() {
  echo "Update MySQL Root Passowrd"
  
  export ROOTMYQL=`cat /share/.my.p|grep root`
  export ROOTMYQLP=${ROOTMYQL:5}
  echo "----------------------------"
  echo "ROOTMYQLP: "${ROOTMYQLP}
  echo "----------------------------"
  mysql -u root -v -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOTMYQLP}';"
  echo "Display databases"
  mysql -u root -v -p${ROOTMYQLP} -e "show databases;"
  echo "MySQL root passwrod updated"

  #set login path
  set_root_login_path

  echo "Finish - update_mysql_root_password"
}


function set_root_login_path() {

  echo "Set Root login-path"
  export ROOTMYQL=`cat /share/.my.p|grep root`
  export ROOTMYQLP=${ROOTMYQL:5}
  

  echo "Create my.cnf file "
  echo "[client]" > ~/.my.cnf
  echo "user=root" >> ~/.my.cnf
  echo "password=${ROOTMYQLP}" >> ~/.my.cnf
  chmod 400 ~/.my.cnf

  echo "Type root passwrod below: "${ROOTMYQLP}
  mysql_config_editor set --login-path=r3306 -u root -p --socket=/var/lib/mysql/mysql.sock

  echo "Validate login path"
  mysql --login-path=r3306 -e "show databases;"
  
  echo "-------------------------------------"
  echo "Login to mysql server as root"
  echo "sudo -s"
  echo "mysql --login-path=r3306 "
  echo ""
  echo "Set login path if you change passwrod as to local server"
  echo "mysql_config_editor set --login-path=r3306 -u root -p --socket=/var/lib/mysql/mysql.sock"
  echo "-------------------------------------"
  echo "Finish - set_root_login_path"
}



##################
# Main
##################

echo "Instal MySQL Server"
#mount share drive 

dnf install -y mysql-server 
#Update configuration of the server 
#sed -i '/^server-id=/d' /etc/my.cnf.d/mysql-server.cnf
#echo "server-id="${HOSTNAME: -1} >> /etc/my.cnf.d/mysql-server.cnf

#Copy configuration files 
cd /etc/my.cnf.d
\cp /etc/my.cnf.d/mysql-server.cnf.app1 /etc/my.cnf.d/mysql-server.cnf

echo "----"
echo "mysql-server.cnf file"
cat /etc/my.cnf.d/mysql-server.cnf

echo "Start MySQLD"
systemctl start mysqld

#Set autostart of mysqld
chkconfig mysqld on

#Installing on server 2
#Generate root and usrrep passwrod and put files on share point and in root file 
# .private 
# .private/my.p
# root:PASSWORD
# repusr:PASSWORD

#Create random string for root and repusr
echo "Create .private folder to store root password"
mkdir ~/.private
chmod 700 ~/.private

echo "Generate root password"
ROOTMYQLP=`tr -dc A-Za-z0-9 </dev/urandom | head -c 20`
export ROOTMYQLP="${ROOTMYQLP:1:8}1Yk"

echo "root:${ROOTMYQLP}" > ~/.private/.my.p
chmod 400 ~/.private/.my.p

cp ~/.private/.my.p /share
chmod 666 /share/.my.p
cat /share/.my.p


#Update root passwrod for MySQL instance
echo "Update root passwrod for MySQL instance"
update_mysql_root_password

#   mysql -u root -e "select user,host from mysql.user;"
#   mysql -u root -e "stop slave; start slave;show slave status\G;"
#   mysql -u root -e "show slave status\G;"
#   mysql -u repusr -p${REPUSRMYQLP} -h demoapp2
# mysql -u repusr -p${REPUSRMYQLP} -h demoapp4



