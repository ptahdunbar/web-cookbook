
include_recipe "nginx"

%w[nginx.conf nginx-common.conf nginx-common-wp.conf].each do |conf|
	template "#{node['nginx']['dir']}/#{conf}" do
		source "nginx/#{conf}.erb"
		owner "root"
		group node['nginx']['root_group']
		mode "0644"
		notifies :reload, 'service[nginx]'
	end
end

template "php-fpm.conf" do
	path "#{node['nginx']['dir']}/conf.d/php-fpm.conf"
	source 'nginx/php-fpm.conf.erb'
	owner "root"
	group node['nginx']['root_group']
	mode "0644"
	notifies :reload, 'service[nginx]'
end

execute "#{node[:nginx][:dir]}/conf.d/default.conf" do
	command "sudo rm #{node[:nginx][:dir]}/conf.d/default.conf"
	not_if { ! File.exists?("#{node[:nginx][:dir]}/conf.d/default.conf") }
end

template "#{node[:nginx][:dir]}/sites-available/default" do
	source 'nginx/default.conf.erb'
end

update_permissions node[:web][:root] do
	group node[:nginx][:group]
end

update_user_group node[:nginx][:group]