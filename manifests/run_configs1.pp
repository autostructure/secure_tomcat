# Runs any tomcat install
class secure_tomcat::run_configs1 {
  create_resources('::tomcat::config::properties::property', $::secure_tomcat::config_properties_properties)

  create_resources('::tomcat::config::server', $::secure_tomcat::config_servers)

  create_resources('::tomcat::config::context', $::secure_tomcat::config_contexts)

  create_resources('::tomcat::config::server::tomcat_users', $::secure_tomcat::config_server_tomcat_users)
}
