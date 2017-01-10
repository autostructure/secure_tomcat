require 'spec_helper'

describe 'secure_tomcat::install' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge(
            staging_http_get: 'curl'
          )
        end

        let(:title) { '/opt/tomcat' }

        let(:params) {
          {
            user:       'tomcat_admin',
            group:      'tomcat',
            source_url: 'https://www-us.apache.org/dist/tomcat/tomcat-7/v7.0.73/bin/apache-tomcat-7.0.73.tar.gz'
          }
        }

        context "secure_tomcat::install class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          # it { is_expected.to contain_class('secure_tomcat::params') }
          # it { is_expected.to contain_class('secure_tomcat::install').that_comes_before('Class[secure_tomcat::config]') }
          # it { is_expected.to contain_class('secure_tomcat::config') }
          # it { is_expected.to contain_class('secure_tomcat::service').that_subscribes_to('Class[secure_tomcat::config]') }

          # it { is_expected.to contain_service('secure_tomcat') }
          # it { is_expected.to contain_package('secure_tomcat').with_ensure('present') }
        end
      end
    end
  end

  # context 'unsupported operating system' do
  #   describe 'secure_tomcat class without any parameters on Solaris/Nexenta' do
  #     let(:facts) do
  #       {
  #         osfamily: 'Solaris',
  #         operatingsystem: 'Nexenta',
  #       }
  #     end

  #     it { expect { is_expected.to contain_package('secure_tomcat') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
  #   end
  # end
end
