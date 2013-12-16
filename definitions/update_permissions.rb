define :update_permissions, :dmode => '775', :fmode => '664', :group => nil, :user => '' do
    execute "update permissions in #{params[:name]}" do
        command "sudo find #{params[:name]} -type d -exec chmod #{params[:dmode]} {} \;"
        command "sudo find #{params[:name]} -type f -exec chmod #{params[:fmode]} {} \;"
        command "sudo chown -R #{params[:user]}:#{params[:group]} #{params[:name]}"
        not_if { ! params[:name] }
    end
end