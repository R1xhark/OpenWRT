#!/usr/bin/env ruby

# Set password for root
def set_root_password
  system('passwd')
end

# Password prompt for TTY and serial console

def enable_autentication
  system('uci set system.@system[0].ttylogin="1"')
  system('uci commit system')
  system('service system start')
end

# ip adress logging - currently commented out due to presence in other scripts
/*
def log_connected_ips
  connected_ips = `arp -n | grep -v incomplete | awk '{print $1}'`.split("\n")

  file.open('/tmp/network_activity.log','a') do |file|
    connected_ips.each do |ip|
      activity = `ping -c 1 #{ip} 2>&1`
      file.puts("#{Time.now} - #{ip} - #{activity}
    end
  end
end
*/
