#!/bin/bash 

DOMAIN=$1

#get root dir from configuration file 
cat /etc/nginx/conf.d/$1.conf|grep "root"|grep "/data/www"|grep -v "#"


ROOT_DIR=`/etc/nginx/conf.d/${DOMAIN}.conf|grep "root"|grep "/data/www"|grep -v "#"|sed -s " "|cut -d " " -f 4|sed 's|;||'`

certbot --webroot -w ${ROOT_DIR}/htdocs  -d ${DOMAIN} -d www.${DOMAIN}

service nginx restart

#dev2.5alarm-bbq.com
#cat /etc/nginx/conf.d/dev2.5alarm-bbq.com.conf|grep "root"|grep "/data/www"|grep -v "#"|sed -s " "|cut -d " " -f 4|sed 's|;||'
