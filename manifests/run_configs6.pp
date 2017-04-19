# Runs any tomcat install
class secure_tomcat::run_configs6 {
  create_resources('::tomcat::config::server::valve', $::secure_tomcat::config_server_valves)
}
