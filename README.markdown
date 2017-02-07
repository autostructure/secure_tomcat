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

## What is Covered
### Profile Definitions
The following configuration profiles are defined by this Benchmark:
#### Level 1
Items in this profile intend to:

 - be practical and prudent;
 - provide a clear security benefit;
 - not inhibit the utility of the technology beyond acceptable means.

#### Level 2
This profile extends the "Level 1" profile. Items in this profile exhibit one or more of the following characteristics:

 - are intended for environments or use cases where security is paramount
 - acts as defense in depth measure
 - may negatively inhibit the utility or performance of the technology

We attempted to cover all Level 1 requirements. Some Level 2 requirements are also implemented.


----------


| Control                                                                                                           | Enforced |   |     | Notes                                                            |
|-------------------------------------------------------------------------------------------------------------------|----------|---|-----|------------------------------------------------------------------|
|                                                                                                                   | Y        | N | N/A |                                                                  |
| Level 1                                                                                                           |          |   |     |                                                                  |
| 1 Remove Extraneous Resources                                                                                     |          |   |     |                                                                  |
| 1.1  Remove extraneous files and directories (Scored)                                                             | X        |   |     |                                                                  |
| 2 Limit Server Platform Information Leaks                                                                         |          |   |     |                                                                  |
| 2.5  Disable client facing Stack Traces (Scored)                                                                  | X        |   |     |                                                                  |
| 2.6  Turn off TRACE (Scored)                                                                                      | X        |   |     |                                                                  |
| 3 Protect the Shutdown Port                                                                                       |          |   |     |                                                                  |
| 3.1  Set a nondeterministic Shutdown command value (Scored)                                                       |          | X |     |                                                                  |
| 4 Protect Tomcat Configurations                                                                                   |          |   |     |                                                                  |
| 4.1  Restrict access to $CATALINA_HOME (Scored)                                                                   | X        |   |     |                                                                  |
| 4.2  Restrict access to $CATALINA_BASE (Scored)                                                                   | X        |   |     |                                                                  |
| 4.3  Restrict access to Tomcat configuration directory (Scored)                                                   | X        |   |     |                                                                  |
| 4.4  Restrict access to Tomcat logs directory (Scored)                                                            | X        |   |     |                                                                  |
| 4.5  Restrict access to Tomcat temp directory (Scored)                                                            | X        |   |     |                                                                  |
| 4.6  Restrict access to Tomcat binaries directory (Scored)                                                        | X        |   |     |                                                                  |
| 4.7  Restrict access to Tomcat web application directory (Scored)                                                 | X        |   |     |                                                                  |
| 4.8  Restrict access to Tomcat catalina.policy (Scored)                                                           | X        |   |     |                                                                  |
| 4.9  Restrict access to Tomcat catalina.properties (Scored)                                                       | X        |   |     |                                                                  |
| 4.10  Restrict access to Tomcat context.xml (Scored)                                                              | X        |   |     |                                                                  |
| 4.11  Restrict access to Tomcat logging.properties (Scored)                                                       | X        |   |     |                                                                  |
| 4.12  Restrict access to Tomcat server.xml (Scored)                                                               | X        |   |     |                                                                  |
| 4.13  Restrict access to Tomcat tomcat-users.xml (Scored)                                                         | X        |   |     |                                                                  |
| 4.14  Restrict access to Tomcat web.xml (Scored)                                                                  | X        |   |     |                                                                  |
| 6 Connector Security                                                                                              |          |   |     |                                                                  |
| 6.2  Ensure SSLEnabled is set to True for Sensitive Connectors (Not Scored)                                       |          |   | X   | Developer must determine if a connector is sensitive.            |
| 6.3  Ensure scheme is set accurately (Scored)                                                                     |          |   | X   | Developer must determine if connector is http or https           |
| 6.4  Ensure secure is set to true only for SSL-enabled Connectors                                                 |          |   |     |                                                                  |
| 6.5 Ensure SSL Protocol is set to TLS for Secure Connectors (Scored)                                              |          |   | X   | Developer must determine if a connector is secure.               |
| 7. Establish and Protect Logging Facilities                                                                       |          |   |     |                                                                  |
| 7.2 Specify file handler in logging.properties files (Scored)                                                     | X        |   |     |                                                                  |
| 7.4 Ensure directory in context.xml is a secure location (Scored)                                                 | X        |   |     |                                                                  |
| 7.5 Ensure pattern in context.xml is correct (Scored)                                                             | X        |   |     |                                                                  |
| 7.6 Ensure directory in logging.properties is a secure location (Scored)                                          | X        |   |     |                                                                  |
| 8. Configure Catalina Policy                                                                                      |          |   |     |                                                                  |
| 8.1 Restrict runtime access to sensitive packages (Scored)                                                        |          | X |     |                                                                  |
| 9. Application Deployment                                                                                         |          |   |     |                                                                  |
| 9.1 Starting Tomcat with Security Manager (Scored)                                                                |          | X |     |                                                                  |
| 10 Miscellaneous Configuration Settings                                                                           |          |   |     |                                                                  |
| 10.1 Ensure Web content directory is on a separate partition from the Tomcat system files (Not Scored)            |          | X |     |                                                                  |
| 10.4 Force SSL when accessing the manager application (Scored)                                                    |          |   | X   | Web manager application Is removed.                              |
| 10.6 Enable strict servlet Compliance (Scored)                                                                    | X        |   |     |                                                                  |
| 10.7 Turn off session facade recycling (Scored)                                                                   | X        |   |     |                                                                  |
| 10.14 Do not allow symbolic linking (Scored)                                                                      | X        |   |     |                                                                  |
| 10.15 Do not run applications as privileged (Scored)                                                              | X        |   |     |                                                                  |
| 10.16 Do not allow cross context requests (Scored)                                                                | X        |   |     |                                                                  |
| 10.18 Enable memory leak listener (Scored)                                                                        | X        |   |     |                                                                  |
| 10.19 Setting Security Liftcycle Listener (Scored)                                                                | X        |   |     |                                                                  |
| 10.20 use the logEffectiveWebXml and metadata-complete settings for deploying applications in production (Scored) |          | X |     |                                                                  |
| Level 2                                                                                                           |          |   |     |                                                                  |
| 1 Remove Extraneous Resources                                                                                     |          |   |     |                                                                  |
| 1.2  Disable Unused Connectors (Not Scored)                                                                       |          |   |     |                                                                  |
| 2 Limit Server Platform Information Leaks                                                                         |          |   |     |                                                                  |
| 2.1  Alter the Advertised server.info String (Scored)                                                             |          |   |     |                                                                  |
| 2.2  Alter the Advertised server.number String (Scored)                                                           |          |   |     |                                                                  |
| 2.3  Alter the Advertised server.built Date (Scored)                                                              |          |   |     |                                                                  |
| 2.4  Disable X-Powered-By HTTP Header and Rename the Server Value for all Connectors (Scored)                     |          |   |     |                                                                  |
| 3.2  Disable the Shutdown port (Not Scored)                                                                       |          |   |     |                                                                  |
| 5 Configure Realms                                                                                                |          |   |     |                                                                  |
| 5.1  Use secure Realms (Scored)                                                                                   |          |   |     |                                                                  |
| 5.2  Use LockOut Realms (Scored)                                                                                  |          |   |     |                                                                  |
| 6 Connector Security                                                                                              |          |   |     |                                                                  |
| 6.1  Setup Client-cert Authentication (Scored)                                                                    |          |   |     |                                                                  |
| 7. Establish and Protect Logging Facilities                                                                       |          |   |     |                                                                  |
| 7.1 Application specific logging (Scored)                                                                         | X        |   |     |                                                                  |
| 7.3 Ensure className is set correctly in context.xml (Scored)                                                     | X        |   |     |                                                                  |
| 7.7 Configure log file size limit (Scored)                                                                        |          | X |     |                                                                  |
| 9. Application Deployment                                                                                         |          |   |     |                                                                  |
| 9.2 Disabling auto deployment of applications (Scored)                                                            |          | X |     |                                                                  |
| 9.3 Disable deploy on startup of applications (Scored)                                                            |          | X |     |                                                                  |
| 10 Miscellaneous Configuration Settings                                                                           |          |   |     |                                                                  |
| 10.2 Restrict access to the web administration (Not Scored)                                                       |          | X |     |                                                                  |
| 10.3 Restrict manager application (Not Scored)                                                                    |          |   | X   | Web manager application Is removed.                              |
| 10.5 Rename the manager application (Scored)                                                                      |          |   | X   | Web manager application Is removed.                              |
| 10.8 Do not allow additional path delimiters (Scored)                                                             |          | X |     |                                                                  |
| 10.9 Do not allow custom header status messages (Scored)                                                          |          | X |     |                                                                  |
| 10.10 Configure connectionTimeout (Scored)                                                                        |          | X |     |                                                                  |
| 10.11 Configure maxHttpHeaderSize (Scored)                                                                        |          | X |     |                                                                  |
| 10.12 Force SSL for all applications (Scored)                                                                     |          | X |     | This requires SSL to be configured; which may not be applicable. |
| 10.17 Do not resolve hosts on logging valves (Scored)                                                             |          | X |     |                                                                  |

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
    '/opt/tomcat7_1' => {
      user       => 'tomcat_admin',
      group      => 'tomcat',
      source_url => 'https://www.apache.org/dist/tomcat/tomcat-7/v7.0.x/bin/apache-tomcat-7.0.x.tar.gz',
    },
    '/opt/tomcat7_2' => {
      user       => 'tomcat_admin',
      group      => 'tomcat',
      source_url => 'http://www-eu.apache.org/dist/tomcat/tomcat-7/v7.0.x/bin/apache-tomcat-7.0.x.tar.gz',
    },
  },
  instances      => {
    'tomcat7_1_1-first'  => {
      catalina_home => '/opt/tomcat7_1',
      catalina_base => '/opt/tomcat7_1/first',
    },
    'tomcat7_1_2-second' => {
      catalina_home => '/opt/tomcat7_1',
      catalina_base => '/opt/tomcat7_1/second',
    },
    'tomcat7_2'        => {
      'catalina_home' => '/opt/tomcat7_2',
    },
  },
  # Change the default port of the second instance server and HTTP connector
  config_servers => {
    'tomcat7_1-second' => {
      catalina_base => '/opt/tomcat8/second',
      port          => '8006',
    },
    # Change tomcat 7_2's server and HTTP/AJP connectors
    'tomcat7_2':
      catalina_base => '/opt/tomcat7_2',
      port          => '8105',
    },
  },
  config_server_connectors => {
    'tomcat7_1-second-http' => {
      catalina_base         => '/opt/tomcat8/second',
      port                  => '8081',
      protocol              => 'HTTP/1.1',
      additional_attributes => {
        'redirectPort' => '8443',
      },
    },
    'tomcat7_2-http' => {
      catalina_base         => '/opt/tomcat6',
      port                  => '8180',
      protocol              => 'HTTP/1.1',
      additional_attributes => {
        'redirectPort' => '8543',
      },
    },
    'tomcat7_2-ajp' => {
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
