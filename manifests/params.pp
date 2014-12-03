# Class: monit::params
#
# This class defines default parameters used by the main module class monit
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to monit class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class monit::params {

  $plugins_dir = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/monit/conf.d',
    default                   => '/etc/monit.d',
  }

  $id_file = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/var/lib/monit/id',
    default                   => '/var/monit/id',
  }

  $state_file = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/var/lib/monit/state',
    default                   => '/var/monit/state',
  }

  $events_file = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/var/lib/monit/events',
    default                   => '/var/monit/events',
  }

  $daemon_interval = '120'
  $daemon_start_delay = ''

  $events_count = '100'

  $mmonit_url = ''
  $alert_rcpt = ''
  $alert_exceptions = ''

  $web_interface_host = ''
  $web_interface_port = '2812'
  $web_interface_allow = 'localhost'

  # Mailserver/s monit will use to send messages.
  # Format: server port
  # Can be an array of mailservers to be tried
  # Format ['server1 port1',...,'serverN portN']
  $mailserver = ''

  ### Application related parameters

  $package = $::operatingsystem ? {
    default => 'monit',
  }

  $service = $::operatingsystem ? {
    default => 'monit',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process = $::operatingsystem ? {
    default => 'monit',
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'monit',
  }

  $process_group = $::operatingsystem ? {
    default => 'monit',

  $config_dir = $::operatingsystem ? {
    default => '/etc/monit',
  }

  $config_file = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/monit/monitrc',
    default                   => '/etc/monit.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0600',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_init = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/monit',
    default                   => '/etc/sysconfig/monit',
  }

  $config_file_init_template = ''

  $pid_file = $::operatingsystem ? {
    default => '/var/run/monit.pid',
  }

  $data_dir = $::operatingsystem ? {
    default => '/etc/monit',
  }

  $log_dir = $::operatingsystem ? {
    default => '/var/log',
  }

  $log_file = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/var/log/monit.log',
    default                   => '',
  }

  $port = ''
  $protocol = 'tcp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $service_autorestart = true
  $version = 'present'
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $monitor = false
  $monitor_tool = ''
  $monitor_target = $::ipaddress
  $firewall = false
  $firewall_tool = ''
  $firewall_src = '0.0.0.0/0'
  $firewall_dst = $::ipaddress
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false

}
