# Runs any tomcat install
class secure_tomcat::harden_instances {
  $::secure_tomcat::instances.each |$name, $params| {
    # 4.2 Restrict access to $CATALINA_BASE
    file { $params['catalina_base']:
      ensure => directory,
      mode   => 'g-w,o-rwx',
      owner  => $params['user'],
      group  => $params['group'],
    }
  }
}
