# Class: secure_tomcat
# ===========================
#
# Full description of class secure_tomcat here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class secure_tomcat (
  $package_name = $::secure_tomcat::params::package_name,
  $service_name = $::secure_tomcat::params::service_name,
) inherits ::secure_tomcat::params {

  # validate parameters here

  class { '::secure_tomcat::install': } ->
  class { '::secure_tomcat::config': } ~>
  class { '::secure_tomcat::service': } ->
  Class['::secure_tomcat']
}
