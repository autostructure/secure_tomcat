# Runs any tomcat install
class secure_tomcat::run_configs5 {
  create_resources('::tomcat::config::server::context', $::secure_tomcat::config_server_contexts)
  create_resources('::tomcat::config::server::listener', $::secure_tomcat::config_server_listeners)
  create_resources('::tomcat::config::server::realm', $::secure_tomcat::config_server_realms)
}
