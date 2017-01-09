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
  Optional[Hash] $instances = undef,
  Boolean $use_manager_application = false,
  String $checked_os_users = 'root',
  String $minimum_umask = '0007'

  ) {
  class {'::secure_tomcat::run_installs': } ->
  class {'::secure_tomcat::harden_installs': }
}
