# DO NOT EDIT - Managed by Puppet


Director { 
  Name = <%= scope.lookupvar('bacula::dir::dir_name') %>
  DIRport = <%= scope.lookupvar('bacula::dir::dir_port') %>
  QueryFile = <%= scope.lookupvar('bacula::dir::query_file') %>
  WorkingDirectory = <%= scope.lookupvar('bacula::dir::working_directory') %>
  PidDirectory = "/var/run"
  Maximum Concurrent Jobs = <%= scope.lookupvar('bacula::dir::max_concurrent_jobs') %>
  Password = <%= scope.lookupvar('bacula::dir::dir_pass') %>
  Messages = <%= scope.lookupvar('bacula::dir::dir_messages') %>
}

<% scope.lookupvar('bacula::dir::job_defs').sort.each do |job_def| -%>
JobDefs {
  Name = <%= job_def['name'] %>
  Type = <%= job_def['type'] %>
  Level = <%= job_def['level'] %>
  Client = <%= job_def['client'] %>
  FileSet = <%= job_def['fileset'] %>
  Schedule = <%= job_def['schedule'] %>
  Storage = <%= job_def['storage'] %>
  Messages = <%= job_def['messages'] %>
  Pool = <%= job_def['pool'] %>
  SpoolAttributes = <%= job_def['spool_attributes'] %>
  Priority = <%= job_def['priority'] %>
  Write Bootstrap = <%= job_def['write_bootstrap'] %>
}  
<% end -%>

Job {
  Name = "BackupClient1"
  JobDefs = "DefaultJob"
}
<% scope.lookupvar('bacula::dir::jobs').sort.each do |job| -%>
Job {
  Name = <%= job['name'] %>
  Client = <%= job['client'] %>
  <% if job['jobdefs'] %>
  JobDefs = <%= job['jobdefs'] %>
  <% end -%>  
  FileSet = <%= job['fileset'] %>
  Type = <%= job['type'] %>
  Schedule = <%= job['schedule'] %>
  Pool = <%= job['pool'] %>
  Messages = <%= job['messages'] %>
  Priority = <%= job['priority'] %>
  Storage = <%= job['storage'] %>
}
<% end -%>


<% scope.lookupvar('bacula::dir::file_sets').sort.each do |file_set| -%>
FileSet {
  Name = <%= file_set['name'] %>
  Include {
    Options {
      signature = <%= file_set['include_signature'] %>
      Compression = <%= file_set['include_compression'] %>
    }
    <% file_set['include_files'].each do |file| -%>
    File = <%= file %>
    <% end -%>
}
  Exclude {
  <% file_set['exclude_files'].each do |file| -%>
    File = <%= file %>
  <% end -%>
}
}
<% end -%>


Schedule {
  Name = "agenda_gfs"
  Run=Differential  Pool=Diaria    monday-thursday at 17:30
  Run=Full         Pool=Semanal   2nd-5th friday at 17:30
  Run=Full         Pool=Mensal    1st friday at 17:30
}

FileSet {
  Name = "Catalog"
  Include {
    Options {
      signature = MD5
      Compression = GZIP
    }
    File = "/opt/bacula/working/bacula.sql"
  }
}


<% scope.lookupvar('bacula::dir::clients').sort.each do |client| -%>
Client {
  Name = <%= client['name'] %>
  Address = <%= client['address'] %>
  FDPort = <%= client['fd_port'] %>
  Catalog = <%= client['catalog'] %>
  Password = <%= client['password'] %>
  File Retention = <%= client['file_retention'] %>
  Job Retention = <%= client['job_retention'] %>
  AutoPrune = <%= client['autoprune'] %>
}
<% end -%>

Storage {
  Name = storage01
# Do not use "localhost" here    
  Address = <%= scope.lookupvar('bacula::dir::sd_address') %>
  SDPort = <%= scope.lookupvar('bacula::dir::sd_port') %>
  Password =  <%= scope.lookupvar('bacula::dir::dir_pass') %>
  Device = DISCO
  Media Type = File
  
}

Catalog {
  Name = MyCatalog
  dbname = "bacula"; dbuser = <%= scope.lookupvar('bacula::dir::db_user') %>; dbpassword = <%= scope.lookupvar('bacula::dir::db_pass') %>
  
}



Messages {
  Name = Daemon
  mail = root@localhost = all, !skipped
  console = all, !skipped, !saved
  append = "/opt/bacula/log/bacula.log" = all, !skipped
}

Messages {
  Name = Standard
  <% if scope.lookupvar('bacula::dir::is_zabbix_integrated') -%>
  mailcommand = "/etc/bacula/bacula-zabbix.bash %i"
  <% end -%>
  mail = 127.0.0.1 = all, !skipped
  console = all, !skipped, !saved
  append = "/tmp/bacula.log" = all, !skipped
  catalog = all
}

Pool {  
  Name = Diaria
  Pool Type = Backup
  Recycle = yes                       # Bacula can automatically recycle$
  AutoPrune = yes                     # Prune expired volumes
  Volume Use Duration = 20 hours
  Volume Retention = 6 days         
  Label Format = "diaria-${NumVols}"
  Maximum Volume Bytes = 50G          # Limit Volume size to something r$
  Maximum Volumes = 100               # Limit number of Volumes in Pool
}

Pool {
  Name = Semanal
  Pool Type = Backup
  Recycle = yes                       # Bacula can automatically recycle$
  AutoPrune = yes                     # Prune expired volumes
  Volume Use Duration = 3 days 
  Volume Retention = 27 days                   
  Label Format = "semanal-${NumVols}"
  Maximum Volume Bytes = 50G          # Limit Volume size to something r$
  Maximum Volumes = 100               # Limit number of Volumes in Pool
}

Pool {
  Name = Mensal
  Pool Type = Backup
  Recycle = yes                       # Bacula can automatically recycle$
  AutoPrune = yes                     # Prune expired volumes
  Volume Use Duration = 3 days
  Volume Retention = 362 days
  Label Format = "mensal-${NumVols}"
  Maximum Volume Bytes = 50G          # Limit Volume size to something r$
  Maximum Volumes = 100               # Limit number of Volumes in Pool
}



Pool {
  Name = Scratch
  Pool Type = Backup
}
#
Console {
  Name = bacula-mon
  Password = <%= scope.lookupvar('bacula::dir::dir_pass') %>
  CommandACL = status, .status
}