begin
File.read('nofile')
rescue Errno::ENOENT => e
puts "ow #{e.class}"
end
