# == Class: tomcat
#
# Class to manage installation and configuration of Tomcat.
#
# === Parameters
#
# [*installs*]
#   Hash of tomcat installations. Required.
#
# [*instances*]
#   Hash of instances to configure. Defaults to empty.
#
# [*wars*]
#   Hash of WARS to deploy. Defaults to empty.
#
# [*config_properties_properties*]
#   Hash of properties to add to catalina.properties. Defaults to empty.
#
# [*config_servers*]
#   Hash of attributes for server elements. Defaults to empty.
#
# [*config_server_connectors*]
#   Hash of connector elements. Defaults to empty.
#
# [*config_server_contexts*]
#   Hash of server context elements. Defaults to empty.
#
# [*config_server_engines*]
#   Hash of server engine elements. Defaults to empty.
#
# [*config_server_globalnamingresources*]
#   Hash of server global naming elements. Defaults to empty.
#
# [*config_server_hosts*]
#   Hash of server host elements. Defaults to empty.
#
# [*config_server_listeners*]
#   Hash of server listner elements. Defaults to empty.
#
# [*config_server_services*]
#   Hash of server service elements. Defaults to empty.
#
# [*config_server_tomcat_users*]
#   Hash of server role elements. Defaults to empty.
#
# [*config_server_valves*]
#   Hash of server valve elements. Defaults to empty.
#
# [*config_contexts*]
#   Hash of context attributes. Defaults to empty.
#
# [*config_context_environments*]
#   Hash of context environment elements. Defaults to empty.
#
# [*config_context_managers*]
#   Hash of context manager elements. Defaults to empty.
#
# [*config_context_resources*]
#   Hash of context resource elements. Defaults to empty.
#
# [*config_context_resourcelinks*]
#   Hash of context resource link elements. Defaults to empty.
#
# [*use_manager_application*]
#   Boolean specifying whether or not to include manager application. Defaults to false.
#
# [*checked_os_users*]
#   String listing users who cannot start the tomcat server. Uses comma delimited string. Defaults to root.
#
# [*minimum_umask*]
#   String listing the minimum umask the tomcat process can be started as. Defaults to 0007.
#
class secure_tomcat (
  Hash $installs,
  Hash $instances = {},
  Hash $wars = {},
  Hash $config_properties_properties = {},
  Hash $config_servers = {},
  Hash $config_server_connectors = {},
  Hash $config_server_contexts = {},
  Hash $config_server_engines = {},
  Hash $config_server_globalnamingresources = {},
  Hash $config_server_hosts = {},
  Hash $config_server_listeners = {},
  Hash $config_server_realms = {},
  Hash $config_server_services = {},
  Hash $config_server_tomcat_users = {},
  Hash $config_server_valves = {},
  Hash $config_contexts = {},
  Hash $config_context_environments = {},
  Hash $config_context_managers = {},
  Hash $config_context_resources = {},
  Hash $config_context_resourcelinks = {},

  Boolean $use_manager_application = false,
  String $checked_os_users = 'root',
  String $minimum_umask = '0007'

  ) {
  class {'::secure_tomcat::run_installs': } ~>
  class {'::secure_tomcat::harden_installs': } ->
  class {'::secure_tomcat::run_instances': } ~>
  class {'::secure_tomcat::harden_instances': } ->
  class {'::secure_tomcat::run_wars': } ->
  class {'::secure_tomcat::deploy_wars': } ->
  class {'::secure_tomcat::configure_wars': } ->
  class {'::secure_tomcat::harden_wars': }
}
