# configure htaccess to point everyone to maintenance page,
# excluding ip addresses

# ErrorDocument 503 /maintenance.html
# Header Set Cache-Control "max-age=0, no-store"

# RewriteEngine On
# RewriteBase /
# RewriteCond %{REMOTE_ADDR} !^203\.97\.89\.51
# RewriteCond %{REMOTE_ADDR} !^125\.236\.210\.45
# RewriteCond %{REMOTE_ADDR} !^127\.0\.0\.1
# RewriteCond %{REQUEST_URI} !^/maintenance\.html$
# RewriteRule ^(.*)$ /maintenance.html [R=307,L]

namespace :htaccess do

	desc "Put site into maintenance mode"
	task :maintenance do

		#upload maintenance page
		file = File.join(Dir.pwd,"maintenance.html")
		if File.exists?(file)
			upload(file, "#{latest_release}/maintenance.html")
		else
			put("Down for maintenance.", "#{latest_release}/maintenance.html")
		end

		allowedips = ""
		if :allowed_ips.kind_of?(Array)
			:allowed_ips.each do |ip|
				allowedips += "RewriteCond %{REMOTE_ADDR} !^" + ip.gsub('.','\.')
			end
		end

		#append htaccess conf
		str = <<-Rewrite
RewriteEngine On \n
RewriteBase / \n
#{allowedips} \n
RewriteCond %{REMOTE_ADDR} !^127\.0\.0\.1 \n
RewriteCond %{REQUEST_URI} !^/maintenance\.html$ \n
RewriteRule ^(.*)$ /maintenance.html [R=307,L]	
		Rewrite

		filename = "#{latest_release}/.htaccess"

		run "echo -e \"#{str}\"|cat - #{filename} > /tmp/out && mv /tmp/out #{filename}"
	end
	
end