# Runs any tomcat install
class secure_tomcat::deploy_wars {
  $::secure_tomcat::wars.each |$name, $params| {
    $array_war = split($name, '.')

    ::staging::extract { $name:
      target  => "${params['catalina_base']}/webapps",
      source  => "${params['catalina_base']}/webapps/${name}",
      creates => "${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF/classes/logging.properties",
    }
  }
}
