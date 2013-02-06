require 'bundler/setup'
Bundler.require(:default)

haproxy = HAProxy.read_stats ENV['SOCKET']
hostname = ENV['HOSTNAME']

haproxy.frontends.each do |frontend| 
  backend = haproxy.backends.select { |backend| frontend[:pxname].match(/#{backend[:pxname]}/) }.first

  puts "servers.#{hostname}.haproxy.#{frontend[:pxname]}.bytes_in #{frontend[:bin]}"
  puts "servers.#{hostname}.haproxy.#{frontend[:pxname]}.bytes_out #{frontend[:bout]}"

  # These stats are empty until the backend server has received a request
  if backend
    puts "servers.#{hostname}.haproxy.#{frontend[:pxname]}.hrsp_1xx #{backend[:hrsp_1xx]}" unless backend[:hrsp_1xx].empty?
    puts "servers.#{hostname}.haproxy.#{frontend[:pxname]}.hrsp_2xx #{backend[:hrsp_2xx]}" unless backend[:hrsp_2xx].empty?
    puts "servers.#{hostname}.haproxy.#{frontend[:pxname]}.hrsp_3xx #{backend[:hrsp_3xx]}" unless backend[:hrsp_3xx].empty?
    puts "servers.#{hostname}.haproxy.#{frontend[:pxname]}.hrsp_4xx #{backend[:hrsp_4xx]}" unless backend[:hrsp_4xx].empty?
    puts "servers.#{hostname}.haproxy.#{frontend[:pxname]}.hrsp_5xx #{backend[:hrsp_5xx]}" unless backend[:hrsp_5xx].empty?
  end
end

haproxy.servers.each do |server|
  puts "servers.#{hostname}.haproxy.#{server[:pxname]}.#{server[:svname]}.bytes_in #{server[:bin]}"
  puts "servers.#{hostname}.haproxy.#{server[:pxname]}.#{server[:svname]}.bytes_out #{server[:bout]}"
  puts "servers.#{hostname}.haproxy.#{server[:pxname]}.#{server[:svname]}.status #{(server[:status] == 'UP') ? 1 : 0}"
  puts "servers.#{hostname}.haproxy.#{server[:pxname]}.#{server[:svname]}.last_chg #{server[:lastchg]}"

  # These stats are empty until the backend server has received a request
  puts "servers.#{hostname}.haproxy.#{server[:pxname]}.#{server[:svname]}.hrsp_1xx #{server[:hrsp_1xx]}" unless server[:hrsp_1xx].empty?
  puts "servers.#{hostname}.haproxy.#{server[:pxname]}.#{server[:svname]}.hrsp_2xx #{server[:hrsp_2xx]}" unless server[:hrsp_2xx].empty?
  puts "servers.#{hostname}.haproxy.#{server[:pxname]}.#{server[:svname]}.hrsp_3xx #{server[:hrsp_3xx]}" unless server[:hrsp_3xx].empty?
  puts "servers.#{hostname}.haproxy.#{server[:pxname]}.#{server[:svname]}.hrsp_4xx #{server[:hrsp_4xx]}" unless server[:hrsp_4xx].empty?
  puts "servers.#{hostname}.haproxy.#{server[:pxname]}.#{server[:svname]}.hrsp_5xx #{server[:hrsp_5xx]}" unless server[:hrsp_5xx].empty?
end

