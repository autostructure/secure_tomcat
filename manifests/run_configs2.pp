# Runs any tomcat install
class secure_tomcat::run_configs2 {
  create_resources('::tomcat::config::server::service', $::secure_tomcat::config_server_services)
  create_resources('::tomcat::config::server::globalnamingresource', $::secure_tomcat::config_server_globalnamingresources)

  create_resources('::tomcat::config::context::environment', $::secure_tomcat::config_context_environments)
  create_resources('::tomcat::config::context::manager', $::secure_tomcat::config_context_managers)
  create_resources('::tomcat::config::context::resource', $::secure_tomcat::config_context_resources)
  create_resources('::tomcat::config::context::resourcelink', $::secure_tomcat::config_context_resourcelinks)
}
