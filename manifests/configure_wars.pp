# Runs any tomcat install
class secure_tomcat::configure_wars {
  $::secure_tomcat::wars.each |$name, $params| {
    $array_war = split($name, '[.]')

    # Ensure necessary files in place
    file {"${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF":
      ensure => directory,
    }

    file {"${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF/web.xml":
      ensure => file,
    }

    file {"${params['catalina_base']}/webapps/${array_war[0]}/META-INF":
      ensure  => directory,
    }

    file {"${params['catalina_base']}/webapps/${array_war[0]}/META-INF/context.xml":
      ensure  => file,
      replace => false,
      content => '<Context/>',
    }

    # 7.1 Application specific logging
    file {"${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF/classes":
      ensure => directory,
    }

    file {"${params['catalina_base']}/webapps/${array_war[0]}/WEB-INF/classes/logging.properties":
      ensure => file,
    }
  }
}
