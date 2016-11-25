require 'spec_helper'

describe 'iscsi::initiator' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  #include_context :hiera

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        # add these two lines in a single test block to enable puppet and hiera debug mode
        # Puppet::Util::Log.level = :debug
        # Puppet::Util::Log.newdestination(:console)
        it do
          is_expected.to compile.with_all_deps
        end

        context 'with no parameters' do

          it do
            is_expected.not_to contain_file('/etc/iscsi/initiatorname.iscsi').with({
              :owner   => "root",
              :group   => "root",
            })

            is_expected.not_to contain_file('/etc/iscsi/initiatorname.iscsi').that_requires('Class[iscsi::install]')
          end

          it do
            is_expected.to contain_file('/etc/iscsi/iscsid.conf').with({
              :owner   => "root",
              :group   => "root",
            })
            is_expected.to contain_file('/etc/iscsi/iscsid.conf').that_requires('Class[iscsi::install]')
          end

          {
            'node.startup' => 'manual',
            'node.leading_login' => 'No',
            'node.session.timeo.replacement_timeout' => '120',
            'node.conn\[0\].timeo.login_timeout' => '15',
            'node.conn\[0\].timeo.logout_timeout' => '15',
            'node.conn\[0\].timeo.noop_out_interval' => '5',
            'node.conn\[0\].timeo.noop_out_timeout' => '5',
            'node.session.err_timeo.abort_timeout' => '15',
            'node.session.err_timeo.lu_reset_timeout' => '30',
            'node.session.err_timeo.tgt_reset_timeout' => '30',
            'node.session.initial_login_retry_max' => '8',
            'node.session.cmds_max' => '128',
            'node.session.queue_depth' => '32',
            'node.session.xmit_thread_priority' => '-20',
            'node.session.iscsi.InitialR2T' => 'No',
            'node.session.iscsi.ImmediateData' => 'Yes',
            'node.session.iscsi.FirstBurstLength' => '',
            'node.session.iscsi.MaxBurstLength' => '',
            'node.conn\[0\].iscsi.MaxRecvDataSegmentLength' => '262144',
            'node.conn\[0\].iscsi.MaxXmitDataSegmentLength' => '0',
            'discovery.sendtargets.iscsi.MaxRecvDataSegmentLength' => '262144',
            'node.conn\[0\].iscsi.HeaderDigest' => 'None',
            'node.conn\[0\].iscsi.DataDigest' => 'None',
            'node.session.nr_sessions' => '1',
            'node.session.iscsi.FastAbort' => 'Yes',
          }.each do |iscsi_setting,value|
            it do
              is_expected.to contain_file('/etc/iscsi/iscsid.conf').with({
                :content => /#{iscsi_setting} = #{value}/
              })
            end
          end

          it do
            is_expected.to contain_class('iscsi::service')
          end

        end

        context 'with initiatorname parameter' do
          let(:params) {
            {
              :initiatorname        => 'myname',
              :node_authmethod      => 'CHAP',
              :discovery_authmethod => 'CHAP',
              :node_authmethod => 'CHAP',
              :discovery_authmethod => 'CHAP',
              :node_username => 'myusername',
              :node_password => 'mypassword',
              :node_username_in => 'my_node_username_in',
              :node_password_in => ',my_node_password_in',
              :discovery_username => 'my_discovery_username',
              :discovery_password => 'my_discovery_password',
              :discovery_username_in => 'my_discovery_username_in',
              :discovery_password_in => 'my_discovery_password_in',
            }
          }

          it do
            is_expected.to contain_file('/etc/iscsi/initiatorname.iscsi').with({
              :owner   => "root",
              :group   => "root",
              :content => /^InitiatorName=myname$/
            })

            is_expected.to contain_file('/etc/iscsi/initiatorname.iscsi').that_comes_before('File[/etc/iscsi/iscsid.conf]')

            is_expected.to contain_file('/etc/iscsi/initiatorname.iscsi').that_requires('Class[iscsi::install]')
          end

          it do
            is_expected.to contain_class('iscsi::service')
          end

          it do
            is_expected.to contain_file('/etc/iscsi/iscsid.conf').with({
              :owner   => "root",
              :group   => "root",
            })
            is_expected.to contain_file('/etc/iscsi/iscsid.conf').that_requires('Class[iscsi::install]')
          end

          {
            'node.session.auth.authmethod' => 'CHAP',
            'discovery.sendtargets.auth.authmethod' => 'CHAP',
            'node.session.auth.username' => 'myusername',
            'node.session.auth.password' => 'mypassword',
            'node.session.auth.username_in' => 'my_node_username_in',
            'node.session.auth.password_in' => ',my_node_password_in',
            'discovery.sendtargets.auth.username' => 'my_discovery_username',
            'discovery.sendtargets.auth.password' => 'my_discovery_password',
            'discovery.sendtargets.auth.username_in' => 'my_discovery_username_in',
            'discovery.sendtargets.auth.password_in' => 'my_discovery_password_in',
          }.each do |iscsi_setting,value|
            it do
              is_expected.to contain_file('/etc/iscsi/iscsid.conf').with({
                :content => /#{iscsi_setting} = #{value}/
              })
            end
          end

        end
      end
    end
  end
end
