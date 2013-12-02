#
# Cookbook Name:: web
# Definition:: webapp
#

define :webapp, :enable => true, :ssl => false, :template => nil, :scm => 'git', :repository => nil, :reference => nil do
	app_enabled = params[:enable]
	document_root = params[:root] ? "#{node[:web][:root]}/#{params[:name]}/#{params[:root]}" : "#{node[:web][:root]}/#{params[:name]}"
	generate_ssl_certs params[:name]

	directory document_root do
		owner params[:user] ? params[:user] : web_user
		group web_group
		mode '0775'
		recursive true
		action :create
	end

	if params[:repository] and params[:reference] do
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

	if ::File.exists?( node[:apache][:dir] )
		template "#{node[:apache][:dir]}/sites-available/#{params[:name]}.conf" do
			source   'apache2/app.conf.erb' unless params[:template]
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
	end

	if ::File.exists?( node[:nginx][:dir] )
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
