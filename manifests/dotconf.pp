#
# = Define: monit::dotconf
#
# The define manages monit dotconf
#
#
# == Parameters
#
# [*ensure*]
#   String. Default: present
#   Manages dotconf presence. Possible values:
#   * 'present' - Install package, ensure files are present.
#   * 'absent' - Stop service and remove package and managed files
#
# [*template*]
#   String. Default: Provided by the module.
#   Sets the path of a custom template to use as content of dotconf
#   If defined, dotconf file has: content => content("$template")
#   Example: template => 'site/dotconf.conf.erb',
#
# [*options*]
#   Hash. Default undef. Needs: 'template'.
#   An hash of custom options to be used in templates to manage any key pairs of
#   arbitrary settings.
#
define monit::dotconf (
  $template,
  $options  = '' ,
  $ensure  = present ) {

  include monit

  file { "monit_dotconf_${name}":
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
