# == Class secure_tomcat::install
#
# This class is called from secure_tomcat for install.
#
define secure_tomcat::install(
  String  $source_url,
  String  $user,
  String  $group,

  String  $catalina_home = $name,
  Boolean $source_strip_first_dir = true,

  Optional[String]  $install_from_source    = undef,

  # source options
  Optional[Boolean] $manage_home            = undef,

  # package options
  Optional[String] $package_ensure         = undef,
  Optional[String] $package_name           = undef,
  Optional[String] $package_options        = undef,

  Boolean $use_manager_application = false,
  String  $checked_os_users = 'root',
  String  $minimum_umask    = '0007',
) {
  $source_url_array = split($source_url, '/')

  tomcat::install { $name:
    catalina_home          => $catalina_home,
    install_from_source    => $install_from_source,

    # source options
    source_url             => $source_url,
    source_strip_first_dir => $source_strip_first_dir,
    user                   => $user,
    group                  => $group,
    manage_user            => true,
    manage_group           => true,
    manage_home            => $manage_home,

    # package options
    package_ensure         => $package_ensure,
    package_name           => $package_name,
    package_options        => $package_options,
  }

  augeas { 'error-page':
    incl    => "${catalina_home}/conf/web.xml",
    lens    => 'Xml.lns',
    context => "/files/${catalina_home}/conf/web.xml/web-app",
    changes => [
      #'set web-app/error-page',
      'set error-page/exception-type/#text java.lang.Throwable',
      'set error-page/location/#text /error.jsp',
      #'set web-app/exception-type',
      #'set web-app/location',
      #"set spec[user = 'joe']/host_group/host ALL",
      #"set spec[user = 'joe']/host_group/command ALL",
      #"set spec[user = 'joe']/host_group/command/runas_user ALL",
    ],
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  # setm /files/Users/bryanbelanger/Downloads/apache-tomcat-7.0.73/conf/server.xml/Server/Service/Connector[*] #attribute/allowTrace false

  # 1.1 Remove extraneous files and directories
  file { "${catalina_home}/webapps/js-examples":
    ensure  => absent,
    force   => true,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  file { "${catalina_home}/webapps/servlet-example":
    ensure  => absent,
    force   => true,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  file { "${catalina_home}/webapps/webdav":
    ensure  => absent,
    force   => true,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  file { "${catalina_home}/webapps/tomcat-docs":
    ensure  => absent,
    force   => true,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  file { "${catalina_home}/webapps/balancer":
    ensure  => absent,
    force   => true,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  file { "${catalina_home}/webapps/ROOT/admin":
    ensure  => absent,
    force   => true,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  file { "${catalina_home}/webapps/examples":
    ensure  => absent,
    force   => true,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  # Unless the user wants the manager application these should also be removed
  unless $use_manager_application {
    file { "${catalina_home}/server/webapps/host-manager":
      ensure  => absent,
      force   => true,
      require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
    }

    file { "${catalina_home}/server/webapps/manager":
      ensure  => absent,
      force   => true,
      require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
    }

    file { "${catalina_home}/conf/Catalina/localhost/host-manager.xml":
      ensure  => absent,
      force   => true,
      require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
    }

    file { "${catalina_home}/conf/Catalina/localhost/manager.xml":
      ensure  => absent,
      force   => true,
      require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
    }
  }

  # 4.1 Remove extraneous files and directories
  exec { "/bin/chmod g-w,o-rwx ${catalina_home}":
    refreshonly => true,
    require     => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
    subscribe   => ["File[${catalina_home}]"],
  }

  exec { "/bin/chown ${user}:${group} ${catalina_home}":
    refreshonly => true,
    require     => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
    subscribe   => ["File[${catalina_home}]"],
  }

  # 4.3 Restrict access to Tomcat configuration directory
  file { "${catalina_home}/conf":
    ensure  => directory,
    mode    => 'g-w,o-rwx',
    owner   => $user,
    group   => $group,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  # 4.4 Restrict access to Tomcat logs directory
  file { "${catalina_home}/logs":
    ensure  => directory,
    mode    => 'o-rwx',
    owner   => $user,
    group   => $group,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  # 4.5 Restrict access to Tomcat temp directory
  file { "${catalina_home}/temp":
    ensure  => directory,
    mode    => 'o-rwx',
    owner   => $user,
    group   => $group,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  # 4.6 Restrict access to Tomcat binaries directory
  file { "${catalina_home}/bin":
    ensure  => directory,
    mode    => 'g-w,o-rwx',
    owner   => $user,
    group   => $group,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  # 4.7 Restrict access to Tomcat web application directory
  file { "${catalina_home}/webapps":
    ensure  => directory,
    mode    => 'g-w,o-rwx',
    owner   => $user,
    group   => $group,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  # 4.8 Restrict access to Tomcat web application directory
  file { "${catalina_home}/conf/catalina.policy":
    ensure  => file,
    mode    => '0770',
    owner   => $user,
    group   => $group,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  # 4.9 Restrict access to Tomcat catalina.properties
  file { "${catalina_home}/conf/catalina.properties":
    ensure  => file,
    mode    => '0770',
    owner   => $user,
    group   => $group,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  # 4.10 Restrict access to Tomcat context.xml
  file { "${catalina_home}/conf/context.xml":
    ensure  => file,
    mode    => 'g-w,o-rwx',
    owner   => $user,
    group   => $group,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  # 4.11 Restrict access to Tomcat logging.properties
  file { "${catalina_home}/conf/logging.properties":
    ensure  => file,
    mode    => 'g-w,o-rwx',
    owner   => $user,
    group   => $group,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  # 4.12 Restrict access to Tomcat server.xml
  file { "${catalina_home}/conf/server.xml":
    ensure  => file,
    mode    => 'g-w,o-rwx',
    owner   => $user,
    group   => $group,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  # 4.13 Restrict access to Tomcat tomcat-users.xml
  file { "${catalina_home}/conf/tomcat-users.xml":
    ensure  => file,
    mode    => 'g-w,o-rwx',
    owner   => $user,
    group   => $group,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  # 4.14 Restrict access to Tomcat web.xml
  file { "${catalina_home}/conf/web.xml":
    ensure  => file,
    mode    => 'g-w,o-rwx',
    owner   => $user,
    group   => $group,
    require => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  # 10.18 Enable memory leak listener
  ::tomcat::config::server::listener {'org.apache.catalina.core.JreMemoryLeakPreventionListener':
    catalina_base   => $catalina_home,
    listener_ensure => present,
    require         => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }

  # 10.19 Setting Security Lifecycle Listener
  ::tomcat::config::server::listener {'org.apache.catalina.security.SecurityListener':
    catalina_base         => $catalina_home,
    listener_ensure       => present,
    additional_attributes => {
      checkedOsUsers => $checked_os_users,
      minimumUmask   => $minimum_umask,
    },
    require               => ["Exec[extract /opt/tomcat-${source_url_array[-1]}]"],
  }
}
