require 'spec_helper_acceptance'

describe 'secure_tomcat defines' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'java' :
        package => 'java-1.8.0-openjdk-devel',
        before  => Class['::secure_tomcat'],
      }

      class { '::secure_tomcat':
        installs                 => {
          '/opt/tomcat8' => {
            user       => 'tomcat_admin',
            group      => 'tomcat',
            source_url => 'https://www.apache.org/dist/tomcat/tomcat-8/v8.0.39/bin/apache-tomcat-8.0.39.tar.gz',
          },
          '/opt/tomcat7' => {
            user       => 'tomcat_admin',
            group      => 'tomcat',
            source_url => 'https://www.apache.org/dist/tomcat/tomcat-7/v7.0.73/bin/apache-tomcat-7.0.73.tar.gz',
          },
        },
        instances                => {
          'tomcat8-first'  => {
            catalina_home => '/opt/tomcat8',
            catalina_base => '/opt/tomcat8/first',
          },
          'tomcat8-second' => {
            catalina_home => '/opt/tomcat8',
            catalina_base => '/opt/tomcat8/second',
          },
          'tomcat7'        => {
            'catalina_home' => '/opt/tomcat7',
          },
        },
        # Change the default port of the second instance server and HTTP connector
        config_servers           => {
          'tomcat8-second' => {
            catalina_base => '/opt/tomcat8/second',
            port          => '8006',
          },
          # Change tomcat 6's server and HTTP/AJP connectors
          'tomcat7'        => {
            catalina_base => '/opt/tomcat7',
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
          'tomcat7-http'        => {
            catalina_base         => '/opt/tomcat7',
            port                  => '8180',
            protocol              => 'HTTP/1.1',
            additional_attributes => {
              'redirectPort' => '8543',
            },
          },
          'tomcat7-ajp'         => {
            catalina_base         => '/opt/tomcat7',
            port                  => '8109',
            protocol              => 'AJP/1.3',
            additional_attributes => {
              'redirectPort' => '8543',
            },
          },
        },
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    # escribe package('secure_tomcat') do
    #   it { is_expected.to be_installed }
    # nd

    # escribe service('secure_tomcat') do
    #   it { is_expected.to be_enabled }
    #   it { is_expected.to be_running }
    # end
  end
end
