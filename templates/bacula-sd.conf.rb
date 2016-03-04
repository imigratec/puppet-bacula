# DO NOT EDIT - Managed by Puppet

Storage {                             
  Name = <%= scope.lookupvar('bacula::sd::sd_name') %>
  SDPort = <%= scope.lookupvar('bacula::sd::sd_port') %>
  WorkingDirectory = <%= scope.lookupvar('bacula::sd::working_directory') %>
  Pid Directory = "/var/run"
  Maximum Concurrent Jobs = <%= scope.lookupvar('bacula::sd::max_concurrent_jobs') %>
}

Director {
  Name = <%= scope.lookupvar('bacula::sd::dir_name') %>
  Password = <%= scope.lookupvar('bacula::sd::dir_pass') %>
}

Director {
  Name = <%= scope.lookupvar('bacula::sd::mon_name') %>
  Password = <%= scope.lookupvar('bacula::sd::mon_pass') %>
  Monitor = yes
}

<% scope.lookupvar('bacula::sd::devices').sort.each do |device| -%>

Device {
  Name = <%= device['name'] %>
  Media Type = <% if device['media_type'] %><%= device['media_type'] %><% else %>File<% end %>
  Archive Device = <%= device['archive_device'] %>
  LabelMedia = <% if device['label_media'] %><%= device['label_media'] %><% else %>yes<% end %>
  Random Access = <% if device['random_access'] %><%= device['random_access'] %><% else %>yes<% end %>
  AutomaticMount = <% if device['automatic_mount'] %><%= device['automatic_mount'] %><% else %>yes<% end %>
  RemovableMedia = <% if device['removable_media'] %><%= device['removable_media'] %><% else %>no<% end %>
  AlwaysOpen = <% if device['always_open'] %><%= device['always_open'] %><% else %>no<% end %>
  Maximum Concurrent Jobs = <% if device['maximum_concurrent_jobs'] %><%= device['maximum_concurrent_jobs'] %><% else %>5<% end %>
}

<% end -%>




Messages {
  Name = <%= scope.lookupvar('bacula::sd::messages_name') %>
  director = bacula-dir = all
}