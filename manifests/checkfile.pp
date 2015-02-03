# Define: monit::checkfile
#
# Basic file checking define that works by pattern matching
#
# Usage:
# With standard template:
# monit::checkfile { "name": 
#  pattern =>  'string to search'}
#
define monit::checkfile (
  $process      = '',
  $processuid   = '',
  $processgid   = '',
  $file         = '',
  $template     = 'monit/checkfile.erb',
  $pattern      = '',
  $startprogram = '',
  $stopprogram  = '',
  $restarts     = '5',
  $cycles       = '5',
  $failaction   = 'timeout',
  $enable       = true ) {

  $ensure=bool2ensure($enable)

  include monit

  $real_file = $file ? {
    ''      => $name,
    default => $file,
  }

  $real_pattern = $pattern
  $real_process = $process

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

  file { "MonitCheckFile_${name}":
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
