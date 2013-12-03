#
# Cookbook Name:: web
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "git"
include_recipe "subversion"
include_recipe "web::default_site"

if node[:web][:platform]
	case node[:web][:platform]
	when 'apache'
		include_recipe "web::apache"
	when 'nginx'
		include_recipe "web::nginx"
	end
end