### BACULA CONFIG ###

# Use 'M' for MySQL
# Use 'P' for PostgreSQL
baculaDbSgdb='P'

# IP address or FQDN of database server
baculaDbAddr='127.0.0.1'

# TCP port of database server
baculaDbPort=<%= scope.lookupvar('bacula::dir::db_port') %>

# Name of the database used by Bacula
baculaDbName='<%= scope.lookupvar('bacula::dir::db_name') %>'

# User used by Bacula on it's database
baculaDbUser='<%= scope.lookupvar('bacula::dir::db_user') %>'

# Password used by Bacula on it's database
baculaDbPass='<%= scope.lookupvar('bacula::dir::db_pass') %>'


### ZABBIX CONFIG ###

# IP address or FQDN of Zabbix server
zabbixSrvAddr='<%= scope.lookupvar('bacula::dir::zabbix_server') %>'


# TCP port of Zabbix server
zabbixSrvPort='<%= scope.lookupvar('bacula::dir::zabbix_server_port') %>'

# Path to zabbix_sender command
zabbixSender='<%= scope.lookupvar('bacula::dir::zabbix_sender') %>'
