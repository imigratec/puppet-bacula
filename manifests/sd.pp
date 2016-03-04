class bacula::sd(
  $sd_name           = 'bacula-sd',
  $sd_pass           = "${hostname}_bacula_sd_password",
  $sd_port           = 9103,
  $dir_name          = 'bacula-dir',
  $messages_name     = 'Standard',
  $mon_name          = 'bacula-mon',
  $dir_pass          = "${hostname}_bacula_dir_password",
  $mon_pass          = "${hostname}_bacula_mon_password",
  $working_directory = '/etc/bacula',
  $max_concurrent_jobs = 20,
  $devices           = {},
){
  
#  notify { "Installing bacula-sd on ${hostname}": }  
 

  package { 'bacula-sd-pgsql': ensure => installed }
  service { 'bacula-sd':
   ensure  => running,
   enable  => true,
   require => Package['bacula-sd-pgsql'],
  }
  file { '/etc/bacula/bacula-sd.conf':
   owner   => root,
   group   => root,
   mode    => 640,
   require => Package['bacula-sd-pgsql'],
   content => template('bacula/bacula-sd.conf.rb'),
   notify  => Service['bacula-sd']
  }
  
}