Two servers architecture 
1. App1 - application server - nginx, php
2. App2 - MySQL database

REPO 

OCI-1APP-1DB-SERVER

Script is desing to install application to run Nginx, PHP, MySQL server on set of 4 servers in OCI Cloud.

Run below comands on respective servers as OPC user 
SErver name has should be name like 

somethingappX

...app1
...app2
##########
Cloud Init script 
#!/bin/bash 
/bin/dnf -y update

##########
app1
##########
#!/bin/bash
export IP_SUBNET=10.10.1
export REPO_BRANCH=dev-1
export REPO_NAME=oci-1app-1db-server
REPODIR=${HOME}/repository/${REPO_BRANCH}
cd ${HOME}
rm -rf * 
mkdir -p ${REPODIR}
cd ${REPODIR}
wget https://github.com/mantonik/${REPO_NAME}/archive/refs/heads/${REPO_BRANCH}.zip
unzip ${REPO_BRANCH}.zip
cp -a ${REPO_NAME}-${REPO_BRANCH}/server-config/* ${HOME}/
cd ${HOME}
ls -l

sudo ./bin/01.install-server.sh


###########################
app2, app3, app4
###########################
#!/bin/bash
IP_SUBNET=10.10.1
export REPO_BRANCH=dev-1
export REPO_NAME=oci-1app-1db-server
export REPODIR=${HOME}/repository/${BRANCH}
export https_proxy=http://${IP_SUBNET}.11:3128;
export http_proxy=http://${IP_SUBNET}.11:3128;
. /etc/profile
cd ${HOME}
rm -rf * 
mkdir -p ${REPODIR}
cd ${REPODIR}
wget https://github.com/mantonik/${REPO_NAME}/archive/refs/heads/${REPO_BRANCH}.zip
unzip ${REPO_BRANCH}.zip
cp -a ${REPO_NAME}-${REPO_BRANCH}/server-config/* ${HOME}/
cd ${HOME}
ls -l

sudo $HOME/bin/01.install-server.sh

###########
To create DB execute script 

create_database.sh 


#########




For support requests allow SSH access from IP:  107.150.23.152

# on app1 servers set ntfs share drive which will be mounted on other server for instalation purpose.
# this way repository need to be sync only to single server app1 not rest of the servers.
#
# rclone for mounting remote drives like google drive for backup purpose.
#
#
#

#########

rm -rf /share
dnf remove -y nginx php php-fpm php-mysqlnd php-json sendmail htop tmux mc rsync clamav clamav-update rclone setroubleshoot-server setools-console nfs-utils

# Remove MySQL sever 
service mysqld stop 
dnf remove -y mysql-server
rm -rf /var/lib/mysql





#########

