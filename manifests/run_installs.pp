# Runs any tomcat install
class secure_tomcat::run_installs {
  create_resources('::tomcat::install', $::secure_tomcat::installs)
}
