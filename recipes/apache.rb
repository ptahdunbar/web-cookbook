apt_repository 'libapache2-mod-fastcgi' do
	uri        'http://us.archive.ubuntu.com/ubuntu/'
	components ['quantal', 'multiverse']
end

include_recipe 'apache2'
include_recipe 'apache2::mod_ssl'
include_recipe 'apache2::mod_actions'
include_recipe 'apache2::mod_fastcgi'
include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_ssl'

directory node[:web][:root] do
	owner node[:apache][:user]
	group node[:apache][:group]
	mode '0775'
	recursive true
	action :create
end

template 'apache2.conf' do
	case node['platform_family']
		when 'rhel', 'fedora', 'arch'
		path "#{node[:apache][:dir]}/conf/httpd.conf"
	when 'debian'
		path "#{node[:apache][:dir]}/apache2.conf"
	when 'freebsd'
		path "#{node[:apache][:dir]}/httpd.conf"
	end

	source   'apache/apache2.conf.erb'
	owner    'root'
	group    node[:apache][:root_group]
	mode     '0644'
	notifies :restart, 'service[apache2]'
end

template "php-fpm.conf" do
	path "#{node[:apache][:dir]}/conf.d/php-fpm.conf"
	source 'apache/php-fpm.conf.erb'
	owner "root"
	group node[:apache][:root_group]
	mode "0644"
	notifies :reload, 'service[apache2]'
end

template "#{node[:apache][:dir]}/sites-available/default" do
	source 'apache/default.conf.erb'

	if ::File.exists?("#{node[:apache][:dir]}/sites-enabled/#{params[:name]}.conf")
		notifies :reload, 'service[apache2]'
	end
end

update_permissions node[:web][:root] do
	group node[:apache][:group]
end

update_user_group node[:apache][:group]