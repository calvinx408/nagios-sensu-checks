###Written by Calvin Bui 11-30-2015
cmd = `powershell.exe (gwmi -Namespace root\\wmi -Class mpio_disk_info).driveinfo`



error=0
storage= Hash.new

cmd.each_line do |line|
  if line =~ /Name\s+:\s+MPIO\s+(\S+)/
    $volume=$1
  elsif line =~ /NumberPaths\s+:\s+(\d+)/
    npath= $1
    #puts $volume
    #puts npath
    storage[:"#{$volume}"] = npath
  end
end

#keys= storage.keys
#puts "#{keys}"

storage.each do |name,p|
  path = Integer(p)
  if path == 8
    print "OK:#{name}=#{path},"
  else
    print "CRITICAL:#{name}=#{path},"
    error+=1
  end
#  puts "#{name} #{p}"
end

if error > 0
  exit(2)
else
  exit(0)
end


print "Number of Volumes with path down: #{error}"
