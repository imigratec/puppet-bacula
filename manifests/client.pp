class bacula::client(
  $fd_name      = "${hostname}",
  $fd_pass  = "${hostname}_bacula_fd_password",
  $fd_port      = 9102,
  $dir_name     = 'bacula-dir',
  $mon_name     = 'bacula-mon',
  $mon_pass = "${hostname}_bacula_mon_password",
  $max_concurrent_jobs = 20,
  $working_directory = '/etc/bacula'
){

#	notify { "Installing bacula-client! on ${hostname}": }  
#	notify { "Bacula MON Password ${mon_pass}": }  
#	notify { "Bacula FD Password ${fd_pass}": }
 

	package { 'bacula-client': ensure => installed }
	service { 'bacula-fd':
	 ensure  => running,
	 enable  => true,
	 require => Package['bacula-client'],
	}
	file { '/etc/bacula/bacula-fd.conf':
	 owner   => root,
	 group   => root,
	 mode    => 640,
	 require => Package['bacula-client'],
	 content => template('bacula/bacula-fd.conf.rb'),
	 notify  => Service['bacula-fd']
	}
  
  }
