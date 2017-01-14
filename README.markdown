[![Build Status](https://travis-ci.org/autostructure/secure_tomcat.svg?branch=master)](https://travis-ci.org/autostructure/secure_tomcat)
[![Puppet Forge](https://img.shields.io/puppetforge/v/autostructure/secure_tomcat.svg)](https://forge.puppetlabs.com/autostructure/secure_tomcat)
[![Puppet Forge](https://img.shields.io/puppetforge/f/autostructure/secure_tomcat.svg)](https://forge.puppetlabs.com/autostructure/secure_tomcat)

#secure_tomcat

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with tomcat](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with tomcat](#beginning-with-tomcat)
4. [Usage - Configuration options and additional functionality](#usage)
    * [I want to install Tomcat from a specific source.](#i-want-to-install-tomcat-from-a-specific-source)
    * [I want to run multiple copies of Tomcat on a single node.](#i-want-to-run-multiple-copies-of-tomcat-on-a-single-node)
    * [I want to deploy WAR files.](#i-want-to-deploy-war-files)
    * [I want to change my configuration](#i-want-to-change-my-configuration)
    * [I want to manage a Connector or Realm that already exists](#i-want-to-manage-a-connector-or-realm-that-already-exists)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

##Overview

The secure_tomcat module lets you use Puppet to install, deploy, and configure Tomcat web services that meet Security Configuration Benchmark for Apache Tomcat 7.0 standards.

##Module Description

Secure Tomcat wraps the Puppet supported Tomcat module. The types are exactly the same.

The biggest difference is all of the types are passed as a has to the secure_tomcat tomcat class.

##Setup

###Setup requirements

The secure_tomcat module requires [puppetlabs-tomcat](https://forge.puppetlabs.com/puppetlabs/tomcat) version 4.0 or newer. On Puppet Enterprise you must meet this requirement before installing the module. To update stdlib, run:

~~~
puppet module upgrade puppetlabs-tomcat
~~~

### Beginning with tomcat

The simplest way to get Tomcat up and running with the secure_tomcat module is to install the Tomcat source and start the service:

```puppet
class { '::secure_tomcat':
  installs => {
    '/opt/tomcat' => {
      user        => 'tomcat_admin',
      group       => 'tomcat',
      source_url  => 'https://www-us.apache.org/dist/tomcat/tomcat-7/v7.0.73/bin/apache-tomcat-7.0.73.tar.gz',
    }
  },
  instances => {
    'default' => {
      'catalina_base' => '/opt/tomcat',
    }
  }
}
```

> Note: look up the correct version you want to install on the [version list](http://tomcat.apache.org/whichversion.html).

## Usage
### I want to run multiple instances of multiple versions tomcat

```puppet
class { 'java': }

class { '::secure_tomcat':
  installs       => {
    '/opt/tomcat8' => {
      user       => 'tomcat_admin',
      group      => 'tomcat',
      source_url => 'https://www.apache.org/dist/tomcat/tomcat-8/v8.0.x/bin/apache-tomcat-8.0.x.tar.gz',
    },
    '/opt/tomcat6' => {
      user       => 'tomcat_admin',
      group      => 'tomcat',
      source_url => 'http://www-eu.apache.org/dist/tomcat/tomcat-6/v6.0.x/bin/apache-tomcat-6.0.x.tar.gz',
    },
  },
  instances      => {
    'tomcat8-first'  => {
      catalina_home => '/opt/tomcat8',
      catalina_base => '/opt/tomcat8/first',
    },
    'tomcat8-second' => {
      catalina_home => '/opt/tomcat8',
      catalina_base => '/opt/tomcat8/second',
    },
    'tomcat6'        => {
      'catalina_home' => '/opt/tomcat6',
    },
  },
  # Change the default port of the second instance server and HTTP connector
  config_servers => {
    'tomcat8-second' => {
      catalina_base => '/opt/tomcat8/second',
      port          => '8006',
    },
    # Change tomcat 6's server and HTTP/AJP connectors
    'tomcat6':
      catalina_base => '/opt/tomcat6',
      port          => '8105',
    },
  },
  config_server_connectors => {
    'tomcat8-second-http' => {
      catalina_base         => '/opt/tomcat8/second',
      port                  => '8081',
      protocol              => 'HTTP/1.1',
      additional_attributes => {
        'redirectPort' => '8443',
      },
    },
    'tomcat6-http' => {
      catalina_base         => '/opt/tomcat6',
      port                  => '8180',
      protocol              => 'HTTP/1.1',
      additional_attributes => {
        'redirectPort' => '8543',
      },
    },
    'tomcat6-ajp' => {
      catalina_base         => '/opt/tomcat6',
      port                  => '8109',
      protocol              => 'AJP/1.3',
      additional_attributes => {
        'redirectPort' => '8543',
      },
    },
  }
}
```

> Note: look up the correct version you want to install on the [version list](http://tomcat.apache.org/whichversion.html).

### I want to deploy WAR files

Add the following to any existing installation with your own war source:
```puppet
tomcat::war { 'sample.war':
  catalina_base => '/opt/tomcat8/first',
  war_source    => '/opt/tomcat8/webapps/docs/appdev/sample/sample.war',
}
```

The name of the WAR file must end with '.war'.

The `war_source` can be a local path or a `puppet:///`, `http://`, or `ftp://` URL.

### I want to remove some configuration

Different configuration defines will allow an ensure parameter to be passed, though the name may vary based on the define.

To remove a connector, for instance, the following configuration ensure that it is absent:

```puppet
tomcat::config::server::connector { 'tomcat8-jsvc':
  connector_ensure => 'absent',
  catalina_base    => '/opt/tomcat8/first',
  port             => '8080',
  protocol         => 'HTTP/1.1',
}
```

### I want to manage a Connector or Realm that already exists

Describe the Realm or HTTP Connector element using `tomcat::config::server::realm` or `tomcat::config::server::connector`, and set `purge_realms` or `purge_connectors` to 'true'.

```puppet
tomcat::config::server::realm { 'org.apache.catalina.realm.LockOutRealm':
  realm_ensure => 'present',
  purge_realms => true,
}
```

Puppet removes any existing Connectors or Realms and leaves only the ones you've specified.

##Reference

###Classes

####Public Classes

* `secure_tomcat`: Main class. Manages some of the defaults for installing and configuring Tomcat.

####Private Classes

* `secure_tomcat::run_installs'`:     Runs all defined installs
* `secure_tomcat::harden_installs'`:  Hardens installs
* `secure_tomcat::run_instances'`:    Runs all defined instances
* `secure_tomcat::harden_instances'`: Hardens instances
* `secure_tomcat::run_wars'`:         Runs all defined wars
* `secure_tomcat::deploy_wars'`:      Deploys war files into webapps
* `secure_tomcat::configure_wars'`:   Preps war files for hardening
* `secure_tomcat::harden_wars'`:      Hardens web applications
* `secure_tomcat::configure'`:        Hardens other components of applications

###Parameters

All parameters are optional except where otherwise noted.

####secure_tomcat
The base class which manages all installations and resources.

#####`instances`

Hash of instances to configure. Defaults to empty.

#####`wars`

Hash of WARS to deploy. Defaults to empty.

#####`config_properties_properties`

Hash of properties to add to catalina.properties. Defaults to empty.

#####`config_servers`

Hash of attributes for server elements. Defaults to empty.

#####`config_server_connectors`

Hash of connector elements. Defaults to empty.

#####`config_server_contexts`

Hash of server context elements. Defaults to empty.

#####`config_server_engines`

Hash of server engine elements. Defaults to empty.

#####`config_server_globalnamingresources`

Hash of server global naming elements. Defaults to empty.

#####`config_server_hosts`

Hash of server host elements. Defaults to empty.

#####`config_server_listeners`

Hash of server listner elements. Defaults to empty.

#####`config_server_services`

Hash of server service elements. Defaults to empty.

#####`config_server_tomcat_users`

Hash of server role elements. Defaults to empty.

#####`config_server_valves`

Hash of server valve elements. Defaults to empty.

#####`config_contexts`

Hash of context attributes. Defaults to empty.

#####`config_context_environments`

Hash of context environment elements. Defaults to empty.

#####`config_context_managers`

Hash of context manager elements. Defaults to empty.

#####`config_context_resources`

Hash of context resource elements. Defaults to empty.

#####`config_context_resourcelinks`

Hash of context resource link elements. Defaults to empty.

#####`use_manager_application`

Boolean specifying whether or not to include manager application. Defaults to false.

#####`checked_os_users`

String listing users who cannot start the tomcat server. Uses comma delimited string. Defaults to root.

#####`minimum_umask`

String listing the minimum umask the tomcat process can be started as. Defaults to 0007.

##Limitations

This module only supports Tomcat installations on \*nix systems.  The `tomcat::config::server*` defines require Augeas version 1.0.0 or newer.

###Multiple Instances

Some Tomcat packages do not let you install more than one instance. You can avoid this limitation by installing Tomcat from source.

##Development

Puppet Labs modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. We can't access the huge number of platforms and myriad of hardware, software, and deployment configurations that Puppet is intended to serve.

We want to keep it as easy as possible to contribute changes so that our modules work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things.

For more information, see our [module contribution guide.](https://docs.puppetlabs.com/forge/contributing.html)

###Contributors

To see who's already involved, see the [list of contributors.](https://github.com/puppetlabs/puppetlabs-tomcat/graphs/contributors)

###Running tests

This project contains tests for both [rspec-puppet](http://rspec-puppet.com/) and [beaker-rspec](https://github.com/puppetlabs/beaker-rspec) to verify functionality. For in-depth information, please see their respective documentation.

Quickstart:

    gem install bundler
    bundle install
    bundle exec rake spec
    bundle exec rspec spec/acceptance
    RS_DEBUG=yes bundle exec rspec spec/acceptance
