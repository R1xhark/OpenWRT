#!/usr/bin/env ruby

require 'net/ftp'

# FTP server details
FTP_HOST = 'ftp.example.com'
FTP_USER = 'your_ftp_username'
FTP_PASS = 'your_ftp_password'
REMOTE_PATH = '/path/to/remote/backups/'

# Local configuration files
CONFIG_FILES = ['/etc/config/network', '/etc/config/firewall', '/etc/config/wireless']

# Backup function
def backup_configuration
  timestamp = Time.now.strftime('%Y%m%d%H%M%S')
  backup_dir = "/tmp/config_backup_#{timestamp}"

  # Create a temporary backup directory
  Dir.mkdir(backup_dir)

  # Copy configuration files to the backup directory
  CONFIG_FILES.each do |file|
    system("cp #{file} #{backup_dir}")
  end

  # Compress the backup directory
  system("tar -czf #{backup_dir}.tar.gz #{backup_dir}")

  # Upload the backup to the FTP server
  Net::FTP.open(FTP_HOST, FTP_USER, FTP_PASS) do |ftp|
    ftp.putbinaryfile("#{backup_dir}.tar.gz", "#{REMOTE_PATH}#{File.basename(backup_dir)}.tar.gz")
  end

  # Clean up
  system("rm -rf #{backup_dir} #{backup_dir}.tar.gz")
end

# Run the backup
backup_configuration
puts 'Configuration backup completed!'
