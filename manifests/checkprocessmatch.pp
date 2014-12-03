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
  $template     = 'monit/checkprocessmatch.erb',
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

  $real_pattern = $pattern ? {
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

  $real_processuid = $processuid ? {
    ''      => $monit::process_user,
    default => $processuid,
  }

  $real_processgid = $processgid ? {
    ''      => $monit::process_group,
    default => $processgid,
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
