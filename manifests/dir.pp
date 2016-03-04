class bacula::dir(
  $db_name              = "bacula",
  $db_user              = "bacula",
  $db_pass              = "bacula",
	$dir_name             = "bacula-dir",
	$dir_pass             = "${hostname}_bacula_dir_password",
	$dir_address          = "localhost",
  $dir_port             = 9101,
  $query_file           = "/etc/bacula/query.sql",
  $working_directory    = '/etc/bacula',
  $max_concurrent_jobs  = 20,
  $dir_messages         = "Daemon",
  $is_zabbix_integrated = true,
  $zabbix_server        = "192.168.0.5",
  $zabbix_server_port   = "10051",
  $zabbix_sender        = "/usr/bin/zabbix_sender",
  $sd_address           = '127.0.0.1',
  $sd_port              = 9103,
  $job_defs             = {},
  $jobs                 = {},
  $file_sets            = {},
  $clients              = {},
){
  #notify { "Installing bacula-dir and bacula-console on ${hostname}": }  


  class { 'postgresql::server':
	  ip_mask_allow_all_users    => '0.0.0.0/32',
	  listen_addresses           => '*',
	  ipv4acls                   => ['host all all 192.168.0.0/24 md5'],
	  postgres_password          => 'postgres',
  }
  postgresql::server::role { 'bacula':
    password_hash => postgresql_password('bacula', $db_pass),
  }

  package { ['bacula-director-pgsql','bacula-console']:
     ensure => installed
  }

  service { 'bacula-director':
   ensure  => running,
   enable  => true,
   require => Package['bacula-director-pgsql'],
  }

  file { '/etc/bacula/bacula-dir.conf':
   owner   => root,
   group   => root,
   mode    => 640,
   content => template('bacula/bacula-dir.conf.rb'),
   notify  => Service['bacula-director']
  }


if $is_zabbix_integrated {

	  notify { "Creating zabbix integration files": }

	  file { '/etc/bacula/bacula-zabbix.conf':
	   owner   => root,
	   group   => root,
	   mode    => 640,
	   content => template('bacula/zabbix/bacula-zabbix.conf.rb'),
	  }  
	    
	  file { '/etc/bacula/bacula-zabbix.bash':
	   owner   => root,
	   group   => root,
	   mode    => 640,
	   content => template('bacula/zabbix/bacula-zabbix.bash.rb'),
	 
	  }
 } 
 
 
  file { '/etc/bacula/bconsole.conf':
   owner   => root,
   group   => root,
   mode    => 640,
   require => Package['bacula-console'],
   content => template('bacula/bconsole.conf.rb'),
   notify  => Service['bacula-director']
  }


}