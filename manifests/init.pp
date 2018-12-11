# = Class: monit
#
# This is the main monit class
#
#
# == Parameters

# [*daemon_interval*]
#   Start Monit in the background (run as a daemon) and check services
#   ant these intervals
#   Default: 120 seconds
#
# [*daemon_start_delay*]
#   optional: delay between monit start and the first check for services.
#   Default: Monit check immediately after Monit start)
#
# [*id_file*]
#   Set the location of the Monit id file which stores the unique id for the
#   Monit instance. The id is generated and stored on first Monit start. By
#   Default: the file is placed in $HOME/.monit.id.
#
# [*state_file*]
#   Set the location of the Monit state file which saves monitoring states
#   on each cycle. If the state file is stored on a persistent filesystem,
#   Monit will recover the monitoring state across reboots.
#   If it is on temporary filesystem, the state will be lost on reboot which
#   may be convenient in some situations.
#   Default: the file is placed in $HOME/.monit.state.
#
# [*mailserver*]
#   Set the list of mail servers for alert delivery. Multiple servers may be
#   specified using a comma separator. If the first mail server fails, Monit
#   will use the second mail server in the list and so on. By default Monit uses
#   port 25 - it is possible to override this with the PORT option.
#   Example: localhost
#            ['localhost 2525', 'otherserver', 'lastserver 1212']
#   Default: empty
#
# [*events_file*]
#   By default Monit will drop alert events if no mail servers are available.
#   If you want to keep the alerts for later delivery retry, you can use the
#   EVENTQUEUE statement. The base directory where undelivered alerts will be
#   stored is specified by the BASEDIR option. You can limit the maximal queue
#   size using the SLOTS option (if omitted, the queue is limited by space
#   available in the back end filesystem).
#   Default: operatingsystem dependent
#
# [*events_count*]
#   Limit the events queue size
#   Default: 100
#
# [*mmonit_url*]
#   Send status and events to M/Monit (for more informations about M/Monit
#   see http://mmonit.com/). By default Monit registers credentials with
#   M/Monit so M/Monit can smoothly communicate back to Monit and you don't
#   have to register Monit credentials manually in M/Monit. It is possible to
#   disable credential registration using the commented out option below.
#   Though, if safety is a concern we recommend instead using https when
#   communicating with M/Monit and send credentials encrypted.
#   Default: empty
#
# [*alert_rcpt*]
#   You can set alert recipients whom will receive alerts if/when a
#   service defined in this file has errors. Alerts may be restricted on
#   events by using a filter as in the second example below.
#   Default: empty
#
# [*alert_exceptions*]
#   Do not alert when Monit start,stop or perform a user initiated action
#   set alert manager@foo.bar not on { instance, action }
#   Default: empty
#
# [*web_interface_host*]
#   Monit has an embedded web server which can be used to view status of
#   services monitored and manage services from a web interface. See the
#   Monit Wiki if you want to enable SSL for the web server.
#   Default: localhost
#
# [*web_interface_port*]
#   Port for the web interface
#   Default: 2812
#
# [*web_interface_allow*]
#   Define who can access the admin interface
#   Examples:
#         localhost        # allow localhost to connect to the server and
#         admin:monit      # require user 'admin' with password 'monit'
#         @monit           # allow users of group 'monit' to connect (rw)
#         @users readonly  # allow users of group 'users' to connect readonly
#   Default: localhost
#
# [*plugins_dir*]
#   Directory contaning single configuration snippets
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, monit class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $monit_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, monit main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $monit_source
#
# [*source_dir*]
#   If defined, the whole monit configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $monit_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $monit_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, monit main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $monit_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $monit_options
#
# [*service_autorestart*]
#   Automatically restarts the monit service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $monit_absent
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $monit_disable
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $monit_disableboot
#
# [*monitor*]
#   Set to 'true' to enable monitoring of the services provided by the module
#   Can be defined also by the (top scope) variables $monit_monitor
#   and $monitor
#
# [*monitor_tool*]
#   Define which monitor tools (ad defined in Example42 monitor module)
#   you want to use for monit checks
#   Can be defined also by the (top scope) variables $monit_monitor_tool
#   and $monitor_tool
#
# [*monitor_target*]
#   The Ip address or hostname to use as a target for monitoring tools.
#   Default is the fact $ipaddress
#   Can be defined also by the (top scope) variables $monit_monitor_target
#   and $monitor_target
#
# [*puppi*]
#   Set to 'true' to enable creation of module data files that are used by puppi
#   Can be defined also by the (top scope) variables $monit_puppi and $puppi
#
# [*puppi_helper*]
#   Specify the helper to use for puppi commands. The default for this module
#   is specified in params.pp and is generally a good choice.
#   You can customize the output of puppi commands for this module using another
#   puppi helper. Use the define puppi::helper to create a new custom helper
#   Can be defined also by the (top scope) variables $monit_puppi_helper
#   and $puppi_helper
#
# [*firewall*]
#   Set to 'true' to enable firewalling of the services provided by the module
#   Can be defined also by the (top scope) variables $monit_firewall
#   and $firewall
#
# [*firewall_tool*]
#   Define which firewall tool(s) (ad defined in Example42 firewall module)
#   you want to use to open firewall for monit port(s)
#   Can be defined also by the (top scope) variables $monit_firewall_tool
#   and $firewall_tool
#
# [*firewall_src*]
#   Define which source ip/net allow for firewalling monit. Default: 0.0.0.0/0
#   Can be defined also by the (top scope) variables $monit_firewall_src
#   and $firewall_src
#
# [*firewall_dst*]
#   Define which destination ip to use for firewalling. Default: $ipaddress
#   Can be defined also by the (top scope) variables $monit_firewall_dst
#   and $firewall_dst
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#   Can be defined also by the (top scope) variables $monit_debug and $debug
#
#
# Default class params - As defined in monit::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of monit package
#
# [*service*]
#   The name of monit service
#
# [*service_status*]
#   If the monit service init script supports status argument
#
# [*process*]
#   The name of monit process
#
# [*process_args*]
#   The name of monit arguments. Used by puppi and monitor.
#   Used only in case the monit process name is generic (java, ruby...)
#
# [*process_user*]
#   The name of the user monit runs with. Used by puppi and monitor.
#
# [*process_group*]
#   The name of the group monit runs with. Used by puppi and monitor.
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*config_file_init*]
#   Path of configuration file sourced by init script
#   Currently useful only in Debian (and derivatives?)
#
# [*config_file_init_template*]
#   Path of template file for the configuration file sourced by init script
#   Currently useful only in Debian (and derivatives?)
#
# [*init_opts*]
#   If handling the init config file in Debian (see above), you can pass extra
#   options to the executable
#   Currently useful only in Debian (and derivatives?)
#
# [*pid_file*]
#   Path of pid file. Used by monitor
#
# [*data_dir*]
#   Path of application data directory. Used by puppi
#
# [*log_dir*]
#   Base logs directory. Used also by puppi
#
# [*log_file*]
#   Log file(s). Used also by puppi
#
# [*port*]
#   The listening port, if any, of the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Note: This doesn't necessarily affect the service configuration file
#   Can be defined also by the (top scope) variable $monit_port
#
# [*protocol*]
#   The protocol used by the the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Can be defined also by the (top scope) variable $monit_protocol
#
#
# See README for usage patterns.
#
class monit (
  $plugins_dir               = params_lookup( 'plugins_dir' ),
  $my_class                  = params_lookup( 'my_class' ),
  $daemon_interval           = params_lookup( 'daemon_interval' ),
  $daemon_start_delay        = params_lookup( 'daemon_start_delay' ),
  $mailserver                = params_lookup( 'mailserver' ),
  $id_file                   = params_lookup( 'id_file' ),
  $state_file                = params_lookup( 'state_file' ),
  $events_file               = params_lookup( 'events_file' ),
  $events_count              = params_lookup( 'events_count' ),
  $mmonit_url                = params_lookup( 'mmonit_url' ),
  $alert_rcpt                = params_lookup( 'alert_rcpt' ),
  $alert_exceptions          = params_lookup( 'alert_exceptions' ),
  $web_interface_host        = params_lookup( 'web_interface_host' ),
  $web_interface_port        = params_lookup( 'web_interface_port' ),
  $web_interface_allow       = params_lookup( 'web_interface_allow' ),
  $source                    = params_lookup( 'source' ),
  $source_dir                = params_lookup( 'source_dir' ),
  $source_dir_purge          = params_lookup( 'source_dir_purge' ),
  $template                  = params_lookup( 'template' ),
  $service_autorestart       = params_lookup( 'service_autorestart' , 'global' ),
  $options                   = params_lookup( 'options' ),
  $version                   = params_lookup( 'version' ),
  $absent                    = params_lookup( 'absent' ),
  $disable                   = params_lookup( 'disable' ),
  $disableboot               = params_lookup( 'disableboot' ),
  $monitor                   = params_lookup( 'monitor' , 'global' ),
  $monitor_tool              = params_lookup( 'monitor_tool' , 'global' ),
  $monitor_target            = params_lookup( 'monitor_target' , 'global' ),
  $puppi                     = params_lookup( 'puppi' , 'global' ),
  $puppi_helper              = params_lookup( 'puppi_helper' , 'global' ),
  $firewall                  = params_lookup( 'firewall' , 'global' ),
  $firewall_tool             = params_lookup( 'firewall_tool' , 'global' ),
  $firewall_src              = params_lookup( 'firewall_src' , 'global' ),
  $firewall_dst              = params_lookup( 'firewall_dst' , 'global' ),
  $debug                     = params_lookup( 'debug' , 'global' ),
  $package                   = params_lookup( 'package' ),
  $service                   = params_lookup( 'service' ),
  $service_status            = params_lookup( 'service_status' ),
  $process                   = params_lookup( 'process' ),
  $process_args              = params_lookup( 'process_args' ),
  $process_user              = params_lookup( 'process_user' ),
  $process_group             = params_lookup( 'process_group' ),
  $config_dir                = params_lookup( 'config_dir' ),
  $config_file               = params_lookup( 'config_file' ),
  $config_file_mode          = params_lookup( 'config_file_mode' ),
  $config_file_owner         = params_lookup( 'config_file_owner' ),
  $config_file_group         = params_lookup( 'config_file_group' ),
  $config_file_init          = params_lookup( 'config_file_init' ),
  $config_file_init_template = params_lookup( 'config_file_init_template' ),
  $init_opts                 = params_lookup( 'init_opts' ),
  $pid_file                  = params_lookup( 'pid_file' ),
  $data_dir                  = params_lookup( 'data_dir' ),
  $log_dir                   = params_lookup( 'log_dir' ),
  $log_file                  = params_lookup( 'log_file' ),
  $port                      = params_lookup( 'port' ),
  $protocol                  = params_lookup( 'protocol' )
  ) inherits monit::params {

  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_service_autorestart=any2bool($service_autorestart)
  $bool_absent=any2bool($absent)
  $bool_disable=any2bool($disable)
  $bool_disableboot=any2bool($disableboot)
  $bool_monitor=any2bool($monitor)
  $bool_puppi=any2bool($puppi)
  $bool_firewall=any2bool($firewall)
  $bool_debug=any2bool($debug)

  ### Definition of some variables used in the module
  $manage_package = $monit::bool_absent ? {
    true  => 'absent',
    false => $monit::version,
  }

  $manage_service_enable = $monit::bool_disableboot ? {
    true    => false,
    default => $monit::bool_disable ? {
      true    => false,
      default => $monit::bool_absent ? {
        true  => false,
        false => true,
      },
    },
  }

  $manage_service_ensure = $monit::bool_disable ? {
    true    => 'stopped',
    default =>  $monit::bool_absent ? {
      true    => 'stopped',
      default => 'running',
    },
  }

  $manage_service_autorestart = $monit::bool_service_autorestart ? {
    true    => Service[monit],
    false   => undef,
  }

  $manage_file = $monit::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  if $monit::bool_absent == true
  or $monit::bool_disable == true
  or $monit::bool_disableboot == true {
    $manage_monitor = false
  } else {
    $manage_monitor = true
  }

  if $monit::bool_absent == true
  or $monit::bool_disable == true {
    $manage_firewall = false
  } else {
    $manage_firewall = true
  }

  $bool_start_at_boot = $monit::bool_disableboot ? {
    true    => 'no',
    default => 'yes',
  }

  $array_mailservers = is_array($mailserver) ? {
    false     => $mailserver ? {
      ''      => [],
      default => [$mailserver],
    },
    default   => $mailserver,
  }

  $array_alert_exceptions = is_array($alert_exceptions) ? {
    false     => $alert_exceptions ? {
      ''      => [],
      default => [$alert_exceptions],
    },
    default   => $alert_exceptions,
  }

  $array_web_interface_allow = is_array($web_interface_allow) ? {
    false     => $web_interface_allow ? {
      ''      => [],
      default => [$web_interface_allow],
    },
    default   => $web_interface_allow,
  }

  $manage_file_replace = true

  $manage_file_source = $monit::source ? {
    ''        => undef,
    default   => $monit::source,
  }

  $manage_file_content = $monit::template ? {
    ''        => undef,
    default   => template($monit::template),
  }

  $manage_file_init_content = $monit::config_file_init_template? {
    ''        => undef,
    default   => template($monit::config_file_init_template),
  }

  ### Managed resources
  package { $monit::package:
    ensure  => $monit::manage_package,
  }

  service { 'monit':
    ensure    => $monit::manage_service_ensure,
    name      => $monit::service,
    enable    => $monit::manage_service_enable,
    hasstatus => $monit::service_status,
    pattern   => $monit::process,
    require   => Package[$monit::package],
  }

  file { 'monit.conf':
    ensure  => $monit::manage_file,
    path    => $monit::config_file,
    mode    => $monit::config_file_mode,
    owner   => $monit::config_file_owner,
    group   => $monit::config_file_group,
    require => Package[$monit::package],
    notify  => $monit::manage_service_autorestart,
    source  => $monit::manage_file_source,
    content => $monit::manage_file_content,
    replace => $monit::manage_file_replace,
    audit   => $monit::manage_audit,
  }

  file { 'monit.init':
    ensure  => $monit::manage_file,
    path    => $monit::config_file_init,
    mode    => $monit::config_file_mode,
    owner   => $monit::config_file_owner,
    group   => $monit::config_file_group,
    require => Package[$monit::package],
    content => $monit::manage_file_init_content,
    notify  => $monit::manage_service_autorestart,
  }

  # The whole monit configuration directory can be recursively overriden
  if $monit::source_dir and $monit::source_dir != '' {
    file { 'monit.dir':
      ensure  => directory,
      path    => $monit::config_dir,
      require => Package[$monit::package],
      notify  => $monit::manage_service_autorestart,
      source  => $monit::source_dir,
      recurse => true,
      purge   => $monit::bool_source_dir_purge,
      force   => $monit::bool_source_dir_purge,
      replace => $monit::manage_file_replace,
    }
  }


  ### Include custom class if $my_class is set
  if $monit::my_class and $monit::my_class != '' {
    include $monit::my_class
  }


  ### Provide puppi data, if enabled ( puppi => true )
  if $monit::bool_puppi == true {
    $classvars=get_class_args()
    puppi::ze { 'monit':
      ensure    => $monit::manage_file,
      variables => $classvars,
      helper    => $monit::puppi_helper,
    }
  }


  ### Service monitoring, if enabled ( monitor => true )
  if $monit::bool_monitor == true {
    if $monit::port != '' {
      monitor::port { "monit_${monit::protocol}_${monit::port}":
        protocol => $monit::protocol,
        port     => $monit::port,
        target   => $monit::monitor_target,
        tool     => $monit::monitor_tool,
        enable   => $monit::manage_monitor,
      }
    }
    if $monit::service != '' {
      monitor::process { 'monit_process':
        process  => $monit::process,
        service  => $monit::service,
        pidfile  => $monit::pid_file,
        user     => $monit::process_user,
        argument => $monit::process_args,
        tool     => $monit::monitor_tool,
        enable   => $monit::manage_monitor,
      }
    }
  }


  ### Firewall management, if enabled ( firewall => true )
  if $monit::bool_firewall == true and $monit::port != '' {
    firewall { "monit_${monit::protocol}_${monit::port}":
      source      => $monit::firewall_src,
      destination => $monit::firewall_dst,
      protocol    => $monit::protocol,
      port        => $monit::port,
      action      => 'allow',
      direction   => 'input',
      tool        => $monit::firewall_tool,
      enable      => $monit::manage_firewall,
    }
  }


  ### Debugging, if enabled ( debug => true )
  if $monit::bool_debug == true {
    file { 'debug_monit':
      ensure  => $monit::manage_file,
      path    => "${settings::vardir}/debug-monit",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
    }
  }

}
