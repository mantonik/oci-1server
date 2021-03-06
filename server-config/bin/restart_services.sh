#!/bin/bash 
# Script will restart all key servcies on the server 
#
# run scirpt without parameter in crontab to execure restart with random wait time on each server 
# when pass paramter now ( any parameter), then wait time will be skiped
#
# v 1.0 1/9/2022 Mariusz, initial version 
# 1.1 - add oci agent restart
# 1.2 add nfs service
# 1.3 - update for single app/db server
#############################################################################################
. /etc/profile
version=1.3

if [ $1"x" == "x" ]; then
  #set sleep time that each server will restart services on different time
  RN=`shuf -i 0-180 -n 1`
  echo "Wait for ${RN} seconds"
  sleep ${RN}
fi


echo "Daemon-reload"
systemctl daemon-reload
echo "Restart Oracle Cloud Atent"
systemctl restart oracle-cloud-agent oracle-cloud-agent-updater

echo "Restart nfs mount "
systemctl enable --now nfs-server

 #Restart services 
  echo "------------------"
  echo "Restart services"
  echo "------------------"
  systemctl restart rsyslog
  systemctl restart sendmail
  systemctl restart sshd


if [[ "$HOSTNAME" == *"app1"* ]]; then 
 
  echo "------------------"
  echo "Stop services"
  echo "------------------"
  echo "Stop nginx"
  systemctl stop nginx
  echo "Stop php-fpm"
  systemctl stop php-fpm.service

fi 
if [[ "$HOSTNAME" == *"app2"* ]] ; then
  echo "Stop MySQL "
  #systemctl stop mysqld
fi

echo "------------------"
echo "Start services"
echo "------------------"
if [[ "$HOSTNAME" == *"app2"* ]] ; then
  echo "start MySQL "
  #systemctl start mysqld
fi

if [[ "$HOSTNAME" == *"app1"* ]]; then 
 
  echo "Start php-fpm"
  systemctl start php-fpm.service
  echo "start nginx"
  systemctl start nginx


fi


echo "------------------"
echo "Completed"
echo "------------------"
echo "Version: ${version}"
echo "---------------------------"