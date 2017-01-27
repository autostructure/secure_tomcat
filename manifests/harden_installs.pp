# Runs any tomcat install
class secure_tomcat::harden_installs {
  $::secure_tomcat::installs.each |$catalina_home, $params| {

    # 2.5 Disable client facing Stack Traces
    augeas { "${catalina_home}-error-page":
      incl    => "${catalina_home}/conf/web.xml",
      lens    => 'Xml.lns',
      context => "/files/${catalina_home}/conf/web.xml/web-app",
      changes => [
        'set error-page/exception-type/#text java.lang.Throwable',
        'set error-page/location/#text /error.jsp',
      ],
    }

    # 1.1 Remove extraneous files and directories
    file { "${catalina_home}/webapps/js-examples":
      ensure => absent,
      force  => true,
    }

    file { "${catalina_home}/webapps/servlet-example":
      ensure => absent,
      force  => true,
    }

    file { "${catalina_home}/webapps/webdav":
      ensure => absent,
      force  => true,
    }

    file { "${catalina_home}/webapps/tomcat-docs":
      ensure => absent,
      force  => true,
    }

    file { "${catalina_home}/webapps/balancer":
      ensure => absent,
      force  => true,
    }

    file { "${catalina_home}/webapps/ROOT/admin":
      ensure => absent,
      force  => true,
    }

    file { "${catalina_home}/webapps/examples":
      ensure => absent,
      force  => true,
    }

    # Unless the user wants the manager application these should also be removed
    unless $::secure_tomcat::use_manager_application {
      file { "${catalina_home}/server/webapps/host-manager":
        ensure => absent,
        force  => true,
      }

      file { "${catalina_home}/server/webapps/manager":
        ensure => absent,
        force  => true,
      }

      file { "${catalina_home}/conf/Catalina/localhost/host-manager.xml":
        ensure => absent,
        force  => true,
      }

      file { "${catalina_home}/conf/Catalina/localhost/manager.xml":
        ensure => absent,
        force  => true,
      }
    }

    # 4.1 Remove extraneous files and directories
    exec { "/bin/chmod g-w,o-rwx ${catalina_home}":
      refreshonly => true,
    }

    exec { "/bin/chown ${params['user']}:${params['group']} ${catalina_home}":
      refreshonly => true,
    }

    # 4.3 Restrict access to Tomcat configuration directory
    file { "${catalina_home}/conf":
      ensure => directory,
      mode   => 'g-w,o-rwx',
      owner  => $params['user'],
      group  => $params['group'],
    }

    # 4.4 Restrict access to Tomcat logs directory
    file { "${catalina_home}/logs":
      ensure => directory,
      mode   => 'o-rwx',
      owner  => $params['user'],
      group  => $params['group'],
    }

    # 4.5 Restrict access to Tomcat temp directory
    file { "${catalina_home}/temp":
      ensure => directory,
      mode   => 'o-rwx',
      owner  => $params['user'],
      group  => $params['group'],
    }

    # 4.6 Restrict access to Tomcat binaries directory
    file { "${catalina_home}/bin":
      ensure => directory,
      mode   => 'g-w,o-rwx',
      owner  => $params['user'],
      group  => $params['group'],
    }

    # 4.7 Restrict access to Tomcat web application directory
    file { "${catalina_home}/webapps":
      ensure => directory,
      mode   => 'g-w,o-rwx',
      owner  => $params['user'],
      group  => $params['group'],
    }

    # 4.8 Restrict access to Tomcat web application directory
    file { "${catalina_home}/conf/catalina.policy":
      ensure => file,
      mode   => '0770',
      owner  => $params['user'],
      group  => $params['group'],
    }

    # 4.9 Restrict access to Tomcat catalina.properties
    file { "${catalina_home}/conf/catalina.properties":
      ensure => file,
      mode   => '0770',
      owner  => $params['user'],
      group  => $params['group'],
    }

    # 4.10 Restrict access to Tomcat context.xml
    file { "${catalina_home}/conf/context.xml":
      ensure => file,
      mode   => 'g-w,o-rwx',
      owner  => $params['user'],
      group  => $params['group'],
    }

    # 4.11 Restrict access to Tomcat logging.properties
    file { "${catalina_home}/conf/logging.properties":
      ensure => file,
      mode   => 'g-w,o-rwx',
      owner  => $params['user'],
      group  => $params['group'],
    }

    # 4.12 Restrict access to Tomcat server.xml
    file { "${catalina_home}/conf/server.xml":
      ensure => file,
      mode   => 'g-w,o-rwx',
      owner  => $params['user'],
      group  => $params['group'],
    }

    # 4.13 Restrict access to Tomcat tomcat-users.xml
    file { "${catalina_home}/conf/tomcat-users.xml":
      ensure => file,
      mode   => 'g-w,o-rwx',
      owner  => $params['user'],
      group  => $params['group'],
    }

    # 4.14 Restrict access to Tomcat web.xml
    file { "${catalina_home}/conf/web.xml":
      ensure => file,
      mode   => 'g-w,o-rwx',
      owner  => $params['user'],
      group  => $params['group'],
    }

    # 10.18 Enable memory leak listener
    ::tomcat::config::server::listener {"${catalina_home}-org.apache.catalina.core.JreMemoryLeakPreventionListener":
      class_name      => 'org.apache.catalina.core.JreMemoryLeakPreventionListener',
      catalina_base   => $catalina_home,
      listener_ensure => present,
    }

    # 10.19 Setting Security Lifecycle Listener
    file_line { "${catalina_home}-tomcat_umask":
      ensure => present,
      path   => "${catalina_home}/bin/catalina.sh",
      line   => 'umask 0007',
      after  => '#!/bin/sh',
    }

    file_line { "${catalina_home}-SecurityListener_umask":
      ensure => present,
      path   => "${catalina_home}/bin/catalina.sh",
      line   => 'JAVA_OPTS="$JAVA_OPTS -Dorg.apache.catalina.security.SecurityListener.UMASK=`umask`"',
      match  => '^#JAVA_OPTS="\$JAVA_OPTS -Dorg.apache.catalina.security.SecurityListener.UMASK=`umask`"',
    }

    ::tomcat::config::server::listener {"${catalina_home}-org.apache.catalina.security.SecurityListener":
      class_name            => 'org.apache.catalina.security.SecurityListener',
      catalina_base         => $catalina_home,
      listener_ensure       => present,
      additional_attributes => {
        checkedOsUsers => $::secure_tomcat::checked_os_users,
        minimumUmask   => $::secure_tomcat::minimum_umask,
      },
    }

    # 10.6 Enable strict servlet Compliance
    file_line { "${catalina_home}-strict_servlet_compliance":
      ensure => present,
      path   => "${catalina_home}/bin/catalina.sh",
      line   => 'JAVA_OPTS="$JAVA_OPTS -Dorg.apache.catalina.STRICT_SERVLET_COMPLIANCE=true"',
      after  => '^# ----- Execute.+',
    }
  }
}
