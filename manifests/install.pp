# == Class secure_tomcat::install
#
# This class is called from secure_tomcat for install.
#
class secure_tomcat::install {

  package { $::secure_tomcat::package_name:
    ensure => present,
  }
}
