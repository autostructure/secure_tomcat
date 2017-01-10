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
        installs => {
          '/opt/tomcat' => {
            user        => 'tomcat_admin',
            group       => 'tomcat',
            source_url  => 'https://www-us.apache.org/dist/tomcat/tomcat-7/v7.0.73/bin/apache-tomcat-7.0.73.tar.gz',
          }
        },
        wars => {
          'hello.war' => {
            'catalina_base' => '/opt/tomcat',
            'war_source' => 'https://glassfish.dev.java.net/downloads/quickstart/hello.war',
          }
        }
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
