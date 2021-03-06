if node[:web][:vhosts]
	node[:web][:vhosts].each do |vhost|
		name 			= vhost.include?('name') ? vhost["name"] : vhost
		app_enabled 	= vhost.include?('enabled') ? vhost["enabled"] : true

		webapp name do
			platform 'nginx'
			root vhost["root"] if vhost["root"]
			ssl vhost["ssl"] if vhost["ssl"]
			enabled app_enabled
			aliases vhost["aliases"] if vhost["aliases"]
		end
	end
end