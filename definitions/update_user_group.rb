define :update_user_group do
	if node[:web][:users] and params[:name]
    	node[:web][:users].each do |user|
    		user_exists = Mixlib::ShellOut.new("id #{user} > /dev/null")
    		if (0 == user_exists.exitstatus)
    			Chef::Log.info "[web] Added #{user} to #{params[:name]}"
    			group params[:name] do
    				action :modify
    				members user
    				append true
    			end
    		end
    	end
    end
end