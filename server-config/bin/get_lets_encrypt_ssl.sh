#!/bin/bash 

DOMAIN=$1
#get root dir from configuration file 

ROOT_DIR=

certbot --webroot -w ${LSWS_VH_ROOT}/html  -d ${DOMAIN} -d www.${DOMAIN}

