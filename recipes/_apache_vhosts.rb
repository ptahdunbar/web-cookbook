if node[:web][:vhosts]
	node[:web][:vhosts].each do |vhost|
		name 			= vhost.include?('name') ? vhost["name"] : vhost
		app_enabled 	= vhost.include?('enabled') ? vhost["enabled"] : true

		webapp name do
			platform 'apache'
			root vhost["root"] if vhost["root"]
			ssl vhost["ssl"] if vhost["ssl"]
			enable app_enabled
			aliases vhost["aliases"] if vhost["aliases"]
		end
	end
end