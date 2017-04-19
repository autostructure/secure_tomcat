# Runs any tomcat install
class secure_tomcat::run_configs3 {
  create_resources('::tomcat::config::server::connector', $::secure_tomcat::config_server_connectors)
  create_resources('::tomcat::config::server::engine', $::secure_tomcat::config_server_engines)
}
