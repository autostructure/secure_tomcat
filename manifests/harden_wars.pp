# Runs any tomcat install
class secure_tomcat::harden_wars {
  include ::tomcat

  $::secure_tomcat::wars.each |$name, $params| {
    $array_war = split($name, '[.]')

    #  Make sure catalina_base parameter has a value
    unless $params['catalina_base'] {
      fail('Each WAR entry requires a catalina_base parameter')
    }

    # 10.20 use the logEffectiveWebXml and metadata-complete settings for deploying applications in production

    # Set the metadata-complete value in the web.xml in each of applications to true
    # TO-DO: Investigate and inspect
    # augeas { "${name}_metadata-complete_true":
    #   incl    => "${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF/web.xml",
    #   lens    => 'Xml.lns',
    #   context => "/files/${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF/web.xml/",
    #   changes => [
    #     'set web-app/#attribute/metadata-complete true',
    #     'set web-app/#attribute/version 3.0',
    #   ],
    # }

    # Set the logEffectiveWebXml value in the context.xml in each of applications to true
    # 10.14 Do not allow symbolic linking (Scored)
    # 10.15 Do not run applications as privileged (Scored)
    # 10.16 Do not allow cross context requests (Scored)
    augeas { "${name}_logEffectiveWebXml_true":
      incl    => "${params['catalina_base']}/webapps/${array_war[0]}/META-INF/context.xml",
      lens    => 'Xml.lns',
      context => "/files/${params['catalina_base']}/webapps/${array_war[0]}/META-INF/context.xml/",
      changes => [
        'set Context/#attribute/logEffectiveWebXml true',
        'set Context/#attribute/crossContext false',
        'set Context/#attribute/privileged false',
        'set Context/#attribute/allowLinking false',
      ],
    }

    # 7.2 Specify file handler in logging.properties files
    file_line { "${name}_logging_handler":
      ensure => present,
      path   => "${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF/classes/logging.properties",
      line   => 'handlers=org.apache.juli.FileHandler, java.util.logging.ConsoleHandler',
      match  => '^handlers=',
    }

    file_line { "${name}_logging_level":
      ensure  => present,
      path    => "${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF/classes/logging.properties",
      line    => 'org.apache.juli.FileHandler.level=INFO',
      match   => '^org.apache.juli.FileHandler.level=',
      replace => false,
    }

    # 7.3 Ensure className is set correctly in context.xml
    # 7.4 Ensure directory in context.xml is a secure location
    # 7.5 Ensure pattern in context.xml is correct
    augeas { "${name}_context_loggin":
      incl    => "${params['catalina_base']}/webapps/${array_war[0]}/META-INF/context.xml",
      lens    => 'Xml.lns',
      context => "/files/${params['catalina_base']}/webapps/${array_war[0]}/META-INF/context.xml/",
      changes => [
        'set /files/tmp/Context/Valve/#attribute/className org.apache.catalina.valves.AccessLogValve',
        'set /files/tmp/Context/Valve/#attribute/directory $CATALINA_HOME/logs/',
        'set /files/tmp/Context/Valve/#attribute/prefix access_log',
        'set /files/tmp/Context/Valve/#attribute/fileDateFormat yyyy-MM-dd.HH',
        'set /files/tmp/Context/Valve/#attribute/suffix .log',
        'set /files/tmp/Context/Valve/#attribute/pattern \'%h %t %H cookie:%{SESSIONID}c request:%{SESSIONID}r %m %U %s %q %r\'',
      ],
    }

    # Find user for install or instance
    $user_install = getparam(Tomcat::Install[$params['catalina_base']], 'user')
    $user_base_tomcat = $::tomcat::user

    $group_install = getparam(Tomcat::Install[$params['catalina_base']], 'group')
    $group_base_tomcat = $::tomcat::group

    $user = pick($user_install, $user_base_tomcat)
    $group = pick($group_install, $group_base_tomcat)

    # 7.6 Ensure directory in logging.properties is a secure location
    unless defined(File["${params['catalina_base']}/logs"]) {
      file {"${params['catalina_base']}/logs":
        ensure => directory,
        mode   => 'o-rwx',
        owner  => $user,
        group  => $group,
      }
    }

    file_line { "${name}_fileHandler_directory":
      ensure => present,
      path   => "${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF/classes/logging.properties",
      line   => "${array_war[0]}.org.apache.juli.FileHandler.directory=${params['catalina_base']}/logs",
    }

    file_line { "${name}_fileHandler_prefix":
      ensure => present,
      path   => "${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF/classes/logging.properties",
      line   => "${array_war[0]}.org.apache.juli.FileHandler.prefix=${array_war[0]}.",
    }

    exec { "/bin/chown ${user}:${group} ${params['catalina_base']}/webapps/${name}":
      refreshonly => true,
    }

    exec { "/bin/chown -R ${user}:${group} ${params['catalina_base']}/webapps/${array_war[0]}":
      refreshonly => true,
    }
  }
}
