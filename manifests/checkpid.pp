# Define: monit::checkpid
#
# Basic PID service checking define
#
# Usage:
# With standard template:
# monit::checkpid  { "name": }
#
define monit::checkpid (
  $process      = '',
  $template     = 'monit/checkpid.erb',
  $pidfile      = '',
  $startprogram = '',
  $stopprogram  = '',
  $restarts     = '5',
  $cycles       = '5',
  $failaction   = 'timeout',
  $enable       = 'true' ) {

  $ensure=bool2ensure($enable)

  include monit

  $real_process = $process ? {
    ''      => $process,
    default => $name,
  }

  $real_pidfile = $pidfile ? {
    ''      => "/var/run/$process.pid",
    default => $pidfile,
  }

  $real_startprogram = $startprogram ? {
    ''      => "/etc/init.d/$process start",
    default => $startprogram,
  }

  $real_stopprogram = $stopprogram ? {
    ''      => "/etc/init.d/$process stop",
    default => $stopprogram,
  }

  file { "MonitCheckPid_${name}":
    ensure  => $ensure,
    path    => "${monit::plugins_dir}/${name}",
    mode    => $monit::config_file_mode,
    owner   => $monit::config_file_owner,
    group   => $monit::config_file_group,
    require => Package[$monit::package],
    notify  => $monit::manage_service_autorestart,
    content => template($template),
    replace => $monit::manage_file_replace,
    audit   => $monit::manage_audit,
    noop    => $monit::bool_noops,
  }

}
