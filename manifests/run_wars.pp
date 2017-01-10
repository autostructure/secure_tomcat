# Runs any tomcat install
class secure_tomcat::run_wars {
  create_resources('::tomcat::war', $::secure_tomcat::wars)
}
