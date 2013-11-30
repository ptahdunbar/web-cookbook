define :generate_ssl_certs, :name => 'server' do
	ssl_path = node[:web][:ssl_dir]

	directory ssl_path do
		recursive true
		action :create
	end

	execute "#{params[:name]} - Generate private key" do
    	command "openssl genrsa -out #{ssl_path}/#{params[:name]}.key 2048 2>&1"
    	creates "#{ssl_path}/#{params[:name]}.key"
    	not_if { File.exists?("#{ssl_path}/#{params[:name]}.key") }
    end

    execute "#{params[:name]} - Generate Certificate Signing Request (CSR)" do
    	command "openssl req -new -batch -key #{ssl_path}/#{params[:name]}.key -out #{ssl_path}/#{params[:name]}.csr"
    	creates "#{ssl_path}/#{params[:name]}.csr"
    	not_if { File.exists?("#{ssl_path}/#{params[:name]}.csr") }
    end

    execute "#{params[:name]} - Sign the certificate using the above private key and CSR" do
    	command "openssl x509 -req -days 365 -in #{ssl_path}/#{params[:name]}.csr -signkey #{ssl_path}/#{params[:name]}.key -out #{ssl_path}/#{params[:name]}.cert 2>&1"
    	creates "#{ssl_path}/#{params[:name]}.cert"
    	not_if { File.exists?("#{ssl_path}/#{params[:name]}.cert") }
    end
end