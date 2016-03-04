Director {
  Name = <%= scope.lookupvar('bacula::dir::dir_name') %>
  DIRport = <%= scope.lookupvar('bacula::dir::dir_port') %>
  address = <%= scope.lookupvar('bacula::dir::dir_address') %>
  Password = <%= scope.lookupvar('bacula::dir::dir_pass') %>
}