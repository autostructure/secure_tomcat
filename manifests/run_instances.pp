# Runs any tomcat install
class secure_tomcat::run_instances {
  create_resources('::tomcat::instances', $::secure_tomcat::instances)
}
