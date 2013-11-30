default[:web][:ssl_dir] = '/usr/share/ssl'
default[:web][:root] = '/srv/www'
default[:web][:default_site_dir] = node[:web][:root] + '/default'

default_unless[:nginx][:listen_addresses] = %w[]
default_unless[:nginx][:root_group] = 'root'
