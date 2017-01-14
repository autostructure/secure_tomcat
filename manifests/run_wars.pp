# Runs any tomcat install
class secure_tomcat::run_wars {
  create_resources('::tomcat::war', $::secure_tomcat::wars)

  # It is necessary to create a directory for it for extraction
  $::secure_tomcat::wars.each |$name, $params| {
    $array_war = split($name, '[.]')

    file {"${params['catalina_base']}/webapps/${array_war[0]}":
      ensure => directory,
    }
  }
}
