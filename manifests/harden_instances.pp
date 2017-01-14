# Runs any tomcat install
class secure_tomcat::harden_instances {
  $::secure_tomcat::instances.each |$name, $params| {
    # If cataline base is set then make sure the file exists
    if $params['catalina_base'] {
      # 4.2 Restrict access to $CATALINA_BASE
      exec { "/bin/chmod g-w,o-rwx ${params['catalina_base']}":
        refreshonly => true,
      }

      exec { "/bin/chown ${params['user']}:${params['group']} ${params['catalina_base']}":
        refreshonly => true,
      }
    }
  }
}
