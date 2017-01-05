# == Class secure_tomcat::service
#
# This class is meant to be called from secure_tomcat.
# It ensure the service is running.
#
class secure_tomcat::service {

  service { $::secure_tomcat::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
