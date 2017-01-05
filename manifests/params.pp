# == Class secure_tomcat::params
#
# This class is meant to be called from secure_tomcat.
# It sets variables according to platform.
#
class secure_tomcat::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'secure_tomcat'
      $service_name = 'secure_tomcat'
    }
    'RedHat', 'Amazon': {
      $package_name = 'secure_tomcat'
      $service_name = 'secure_tomcat'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
