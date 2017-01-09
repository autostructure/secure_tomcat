# Definition: tomcat::instance
#
# This define installs an instance of Tomcat.
#
# Parameters:
# - $catalina_home is the root of the Tomcat installation. This parameter only
#   affects the instance when $install_from_source is true. Default:
#   $tomcat::catalina_home
# - $catalina_base is the base directory for the Tomcat instance if different
#   from $catalina_home. This parameter only affects the instance when
#   $install_from_source is true. Default: $catalina_home
# - $install_from_source is a boolean specifying whether or not to install from
#   source. Defaults to true.
# - The $source_url to install from. Required if $install_from_source is true.
# - $source_strip_first_dir is a boolean specifying whether or not to strip
#   the first directory when unpacking the source tarball. Defaults to true
#   when installing from source. Requires puppet/staging > 0.4.0
# - $package_ensure when installing from package, what the ensure should be set
#   to in the package resource.
# - $package_name is the name of the package you want to install. Required if
#   $install_from_source is false.
# - $package_options to pass extra options to the package resource.
# - $user is the owner of the tomcat home and base. Default: $tomcat::user
# - $group is the group of the tomcat home and base. Default: $tomcat::group
define secure_tomcat::instance (
  $catalina_home          = undef,
  $catalina_base          = undef,
  $user                   = undef,
  $group                  = undef,
  $manage_user            = undef,
  $manage_group           = undef,
  $manage_service         = undef,
  $manage_base            = undef,
  $java_home              = undef,
  $use_jsvc               = undef,
  $use_init               = undef,

  #used for single installs. Deprecated?
  $install_from_source    = undef,
  $source_url             = undef,
  $source_strip_first_dir = undef,
  $package_ensure         = undef,
  $package_name           = undef,
  $package_options        = undef,
) {

  ::tomcat::instance { $name:
    catalina_home          => $catalina_home,
    catalina_base          => $catalina_base,
    user                   => $user,
    group                  => $group,
    manage_user            => $manage_user,
    manage_group           => $manage_group,
    manage_service         => $manage_service,
    manage_base            => $manage_base,
    java_home              => $java_home,
    use_jsvc               => $use_jsvc,
    use_init               => $use_init,

    install_from_source    => $install_from_source,
    source_url             => $source_url,
    source_strip_first_dir => $source_strip_first_dir,
    package_ensure         => $package_ensure,
    package_name           => $package_name,
    package_options        => $package_options,
  }
}
