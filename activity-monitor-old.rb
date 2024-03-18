require 'socket'

def log_connected_ips
  # Obtaining IP adresses and storing them in variable connected_ips
  connected_ips = `arp -n | grep -v incomplete | awk '{print $1}'`.split("\n")

  # Logging IPs and their activity
  connected_ips.each do |ip|
    activity = `ping -c 1 #{ip} 2>&1`
    File.open('/tmp/network_activity.log', 'a') do |file|
      file.puts("#{Time.now} - #{ip} - #{activity}")
    end
  end
end

# Re-running the script every 5 minutes
loop do
  log_connected_ips
  sleep(300) # 300 sekund (5 minut)
end
