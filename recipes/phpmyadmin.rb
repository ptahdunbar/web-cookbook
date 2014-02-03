
node.set_unless[:web][:platform] = 'nginx'

webapp node[:web][:phpmyadmin][:vhost] do
    platform node[:web][:platform]
    user 'nginx' == node[:web][:platform] ? node[:nginx][:user] : node[:apache][:user]
    group 'nginx' == node[:web][:platform] ? node[:nginx][:group] : node[:apache][:group]
    root node[:web][:phpmyadmin][:root]
    ssl node[:web][:phpmyadmin][:ssl]
    enabled node[:web][:phpmyadmin][:enabled]
end

git node[:web][:phpmyadmin][:root] do
    user 'nginx' == node[:web][:platform] ? node[:nginx][:user] : node[:apache][:user]
    group 'nginx' == node[:web][:platform] ? node[:nginx][:group] : node[:apache][:group]
    repository node[:web][:phpmyadmin][:repository]
    reference node[:web][:phpmyadmin][:revision]
    action :sync
end

template "#{node[:web][:phpmyadmin][:root]}/config.inc.php" do
    source "pma/config.inc.php.erb"
    mode 0440
    user 'nginx' == node[:web][:platform] ? node[:nginx][:user] : node[:apache][:user]
    group 'nginx' == node[:web][:platform] ? node[:nginx][:group] : node[:apache][:group]
end