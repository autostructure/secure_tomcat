# Runs any tomcat install
class secure_tomcat::harden_wars {
  $::secure_tomcat::wars.each |$name, $params| {
    $array_war = split($name, '.')

    # 10.20 use the logEffectiveWebXml and metadata-complete settings for deploying applications in production

    # Set the metadata-complete value in the web.xml in each of applications to true
    augeas { 'metadata-complete_true':
      incl    => "${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF.web.xml",
      lens    => 'Xml.lns',
      context => "/files/${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF.web.xml/",
      changes => [
        'set web-app/#attribute/metadata-complete true',
      ],
    }

    # Set the logEffectiveWebXml value in the context.xml in each of applications to true
    augeas { 'logEffectiveWebXml_true':
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

    file_line { 'logging_handler':
      ensure => present,
      path   => "${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF/classes/logging.properties",
      line   => 'handlers=org.apache.juli.FileHandler, java.util.logging.ConsoleHandler',
      match  => '^handlers=',
    }

    file_line { 'logging_level':
      ensure  => present,
      path    => "${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF/classes/logging.properties",
      line    => 'org.apache.juli.FileHandler.level=INFO',
      match   => '^org.apache.juli.FileHandler.level=',
      replace => false,
    }
  }
}
