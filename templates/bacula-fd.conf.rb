# DO NOT EDIT - Managed by Puppet

Director {
  Name = <%= scope.lookupvar('bacula::client::dir_name') %>
  Password = "<%= scope.lookupvar('bacula::client::fd_pass') %>"
}
Director {
  Name = <%= scope.lookupvar('bacula::client::mon_name') %>
  Password = "<%= scope.lookupvar('bacula::client::mon_pass') %>"
  Monitor = yes
}
FileDaemon {                          # this is me
  Name = <%= scope.lookupvar('bacula::client::fd_name') %>
  FDport = <%= scope.lookupvar('bacula::client::fd_port') %>                  # where we listen for the director
  WorkingDirectory = <%= scope.lookupvar('bacula::client::working_directory') %>
  Pid Directory = /var/run
  Maximum Concurrent Jobs = <%= scope.lookupvar('bacula::client::max_concurrent_jobs') %>
}
Messages {
  Name = Standard
  director = <%= scope.lookupvar('bacula::client::dir_name') %> = all, !skipped, !restored
}