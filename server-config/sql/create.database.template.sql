CREATE USER 'APPUSER'@'10.10.1.0/24' IDENTIFIED BY 'USRMYQLP';
select user,host from mysql.user;
create database DATABASENAME;
GRANT ALL PRIVILEGES ON DATABASENAME.* TO 'APPUSER'@'10.10.1.0/24';
exit;
