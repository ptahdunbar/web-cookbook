default[:web][:ssl_dir] = '/usr/share/ssl'
default[:web][:root] = '/srv/www'
default[:web][:default_site_dir] = '/usr/share/nginx/default'

default[:web][:phpmyadmin][:vhost] = 'pma.dev'
default[:web][:phpmyadmin][:root] = '/usr/share/phpmyadmin'
default[:web][:phpmyadmin][:ssl] = false
default[:web][:phpmyadmin][:enabled] = true
default[:web][:phpmyadmin][:repository] = 'http://github.com/phpmyadmin/phpmyadmin.git'
default[:web][:phpmyadmin][:revision] = 'STABLE'
default[:web][:phpmyadmin][:allownopassword] = false
default[:web][:phpmyadmin][:uploaddir] = ''

default_unless[:nginx][:listen_addresses] = %w[]
default_unless[:nginx][:root_group] = 'root'
