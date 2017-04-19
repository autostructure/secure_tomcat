# Runs any tomcat install
class secure_tomcat::run_configs4 {
  create_resources('::tomcat::config::server::host', $::secure_tomcat::config_server_hosts)
}
