# Runs any tomcat install
class secure_tomcat::harden_wars {
  $::secure_tomcat::wars.each |$name, $params| {
    $array_war = split($name, '[.]')

    # 10.20 use the logEffectiveWebXml and metadata-complete settings for deploying applications in production

    # Set the metadata-complete value in the web.xml in each of applications to true
    augeas { "${name}_metadata-complete_true":
      incl    => "${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF/web.xml",
      lens    => 'Xml.lns',
      context => "/files/${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF/web.xml/",
      changes => [
        'set web-app/#attribute/metadata-complete true',
      ],
    }

    # Set the logEffectiveWebXml value in the context.xml in each of applications to true
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

    # 7.4 Ensure directory in context.xml is a secure location
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

    # 7.6 Ensure directory in logging.properties is a secure location
    #file {"${params['catalina_base']}/logs":
    #  ensure => directory,
    #  mode   => 'o-rwx',
    #}

    file_line { "${name}_fileHandler_directory":
      ensure => present,
      path   => "${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF/classes/logging.properties",
      line   => "${name}.org.apache.juli.FileHandler.directory=${params['catalina_base']}/logs",
    }

    file_line { "${name}_fileHandler_prefix":
      ensure => present,
      path   => "${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF/classes/logging.properties",
      line   => "${name}.org.apache.juli.FileHandler.prefix=${name}",
    }
  }
}
