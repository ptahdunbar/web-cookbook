#
# Cookbook Name:: web
# Definition:: webapp
#

define :webapp, :platform => nil, :enabled => true, :ssl => false, :template => nil, :scm => 'git', :repository => nil, :reference => nil, :root => nil do

	return if ! params[:platform]

	app_enabled = params[:enabled]
	params[:root] = params[:root] ? "#{node[:web][:root]}/#{params[:name]}/#{params[:root]}" : "#{node[:web][:root]}/#{params[:name]}"
	generate_ssl_certs params[:name]

	case params[:platform]
		when 'apache'
			web_user = node[:apache][:user]
			web_group = node[:apache][:group]
		when 'nginx'
			web_user = node[:nginx][:user]
			web_group = node[:nginx][:group]
	end


	directory params[:root] do
		owner params[:user] ? params[:user] : web_user
		group web_group
		mode '0775'
		recursive true
		action :create
	end

	if params[:repository] and params[:reference]
		case params[:scm]
			when 'git'
				git "#{params[:root]}" do
					repository params[:repository]
					reference params[:reference]
					action :sync
				end
			when 'svn'
				subversion "#{params[:root]}" do
					repository params[:repository]
					reference params[:reference]
					action :sync
				end
		end
	end

	case params[:platform]
		when 'apache'
			template "#{node[:apache][:dir]}/sites-available/#{params[:name]}.conf" do
				source   'apache/app.conf.erb' unless params[:template]
				owner    'root'
				group    node[:apache][:group]
				mode     '0644'
				cookbook params[:cookbook] if params[:cookbook]
				variables(
					:params => params
				)

				if ::File.exists?("#{node[:apache][:dir]}/sites-enabled/#{params[:name]}.conf")
					notifies :reload, 'service[apache]'
				end
			end

			apache_site "#{params[:name]}.conf" do
				enable app_enabled
			end
		when 'nginx'
			template "#{node[:nginx][:dir]}/sites-available/#{params[:name]}.conf" do
				source   'nginx/app.conf.erb' unless params[:template]
				owner    'root'
				group    node[:nginx][:group]
				mode     '0644'
				cookbook params[:cookbook] if params[:cookbook]
				variables(
					:params => params
				)

				if ::File.exists?("#{node[:nginx][:dir]}/sites-enabled/#{params[:name]}.conf")
					notifies :reload, 'service[nginx]'
				end
			end

			nginx_site "#{params[:name]}.conf" do
				enable app_enabled
			end
	end
end
