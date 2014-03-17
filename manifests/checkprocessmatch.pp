# Define: monit::checkprocessmatch
#
# Basic processs checking define that works by pattern matching
# against the process name (command line) in the process table.
#
# Usage:
# With standard template:
# monit::checkprocessmatch { "name": }
#
define monit::checkprocessmatch (
  $process      = '',
  $template     = 'monit/checkprocess.erb',
  $pattern      = '',
  $startprogram = '',
  $stopprogram  = '',
  $restarts     = '5',
  $cycles       = '5',
  $failaction   = 'timeout',
  $enable       = true ) {

  $ensure=bool2ensure($enable)

  include monit

  $real_process = $process ? {
    ''      => $name,
    default => $process,
  }

  $check_type = 'matching'

  $check_argument = $pattern ? {
    ''      => $real_process,
    default => $pattern,
  }

  $real_startprogram = $startprogram ? {
    ''      => "/etc/init.d/${process} start",
    default => $startprogram,
  }

  $real_stopprogram = $stopprogram ? {
    ''      => "/etc/init.d/${process} stop",
    default => $stopprogram,
  }

  file { "MonitCheckProcessMatch_${name}":
    ensure  => $ensure,
    path    => "${monit::plugins_dir}/${name}",
    mode    => $monit::config_file_mode,
    owner   => $monit::config_file_owner,
    group   => $monit::config_file_group,
    require => Package[$monit::package],
    notify  => $monit::manage_service_autorestart,
    content => template($template),
    replace => $monit::manage_file_replace,
  }

}
