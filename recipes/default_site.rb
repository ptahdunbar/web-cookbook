directory node[:web][:default_site_dir] do
	mode 0775
	action :create
	recursive true
end

cookbook_file "#{node[:web][:default_site_dir]}/pirate.gif" do
	source 'pirate.gif'
end

template "#{node[:web][:default_site_dir]}/index.html" do
	source 'default_index.html.erb'
end

generate_ssl_certs "default"