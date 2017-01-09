require 'spec_helper_acceptance'

describe 'secure_tomcat::install defines' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      ::secure_tomcat::install { '/opt/tomcat':
        user        => 'tomcat_admin',
        group       => 'tomcat',
        source_url  => 'https://www-us.apache.org/dist/tomcat/tomcat-7/v7.0.73/bin/apache-tomcat-7.0.73.tar.gz',
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
