#!/bin/bash 

if [ $1"x" == "x" ]; then 
  echo "Enter domain name:"
  read DOMAIN 
else
  DOMAIN=$1
fi

echo "---------------------------"
#get root dir from configuration file 
ROOT_DIR=`/etc/nginx/conf.d/${DOMAIN}.conf|grep "root"|grep "/data/www"|grep -v "#"|sed -s " "|cut -d " " -f 4|sed 's|;||'`

if [ ${ROOT_DIR}"x" == "x" ]; then 
  echo "ROOT directory is empty - exit"
fi

if [ ! -e ${ROOT_DIR} ]; then 
  echo "--------------------------"
  echo "ROOT_DIR " ${ROOT_DIR}
  echo "doesn't exist - exit"
  echo "--------------------------"
fi


echo "Generate Let's encrytp SSL certificate for"
echo "Domain: "${DOMAIN}
echo "ROOT_DIR: " ${ROOT_DIR}
echo "---------------------------"
certbot --webroot -w ${ROOT_DIR}/htdocs  -d ${DOMAIN} -d www.${DOMAIN}

service nginx restart

#dev2.5alarm-bbq.com
#cat /etc/nginx/conf.d/dev2.5alarm-bbq.com.conf|grep "root"|grep "/data/www"|grep -v "#"|sed -s " "|cut -d " " -f 4|sed 's|;||'
