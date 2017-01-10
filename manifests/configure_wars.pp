# Runs any tomcat install
class secure_tomcat::configure_wars {
  $::secure_tomcat::wars.each |$name, $params| {
    $array_war = split($name, '.')

    file { "${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF/classes/logging.properties":
      ensure => file,
    }
  }
}
