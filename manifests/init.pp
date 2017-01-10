# == Class: tomcat
#
# Class to manage installation and configuration of Tomcat.
#
# === Parameters
#
# [*catalina_home*]
#   The base directory for the Tomcat installation. Default: /opt/apache-tomcat
#
# [*user*]
#   The user to run Tomcat as. Default: tomcat
#
# [*group*]
#   The group to run Tomcat as. Default: tomcat
#
# [*manage_user*]
#   Boolean specifying whether or not to manage the user. Defaults to true.
#
# [*purge_connectors*]
#   Boolean specifying whether to purge all Connector elements from server.xml. Defaults to false.
#
# [*purge_realms*]
#   Boolean specifying whether to purge all Realm elements from server.xml. Defaults to false.
#
# [*manage_group*]
#   Boolean specifying whether or not to manage the group. Defaults to true.
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
  class {'::secure_tomcat::run_instances': } ->
  class {'::secure_tomcat::harden_instances': } ->
  class {'::secure_tomcat::run_wars': } ->
  class {'::secure_tomcat::deploy_wars': } ->
  class {'::secure_tomcat::configure_wars': } ->
  class {'::secure_tomcat::harden_wars': } ->
  class {'::secure_tomcat::configure': }
}
