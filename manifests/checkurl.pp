# Define: monit::checkurl
#
# Basic URL checking define
#
# Usage:
# monit::checkurl { 'hostname':
#     fqdn       => 'hostname.example42.com',
#     url        => 'http://hostname.example42.com/check/something.php',
#     content    => 'OKK',
#     failaction => 'exec /etc/restart.d/script.sh',
# }
#
define monit::checkurl (
  $fqdn         = '',
  $template     = 'monit/checkurl.erb',
  $url          = '',
  $content      = '',
  $failaction   = 'alert',
  $enable       = 'true' ) {

  $ensure=bool2ensure($enable)

  include monit

  $real_fqdn = $fqdn ? {
    ''      => "${name}.${::domain}",
    default => $fqdn,
  }

  $real_url = $url ? {
    ''      => "htpp://${real_fqdn}",
    default => $url,
  }

  file { "Monitcheckurl_${name}":
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
