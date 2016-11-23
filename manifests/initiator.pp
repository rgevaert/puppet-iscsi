# == Class: iscsi::initiator
#
# The iscsi::initiator sets up the client configution for servers which connect
# to iscsi machines.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Examples
#
#  class { 'iscsi':
#    startup => 'automatic',
#
#    node_authmethod => 'CHAP'
#    node_username => 'iqn.1993-08.org.debian:01:3181f68bc3dd',
#    node_password => 'jXb8F5uR22KhpJkFTTTYtA',
#    node_username_in => $::iscsi_initiator,
#    node_password_in => 'C9LbgUQGAXGuv4bEjGxgYt',
#
#    discovery_authmethod => 'CHAP',
#    discovery_username => 'iqn.1993-08.org.debian:01:3181f68bc3dd'
#    discovery_password => 'jXb8F5uR22KhpJkFTTTYtA',
#    discovery_username_in => $::iscsi_initiator
#    discovery_password_in => 'C9LbgUQGAXGuv4bEjGxgYt',
#  }
#
#
# === Authors
#
# Robert Hafner <tedivm@tedivm.com>
# Liam Leane <lleane.work@gmail.com>
# Rudy Gevaert <rudy.gevaert@ugent.be>
#
# === Copyright
#
# See LICENSE file distributed with this module.
#
class iscsi::initiator (
  $initiatorname            = $iscsi::params::initiatorname,
  $node_authmethod          = $iscsi::params::node_authmethod,
  $node_username            = $iscsi::params::node_username,
  $node_password            = $iscsi::params::node_password,
  $node_username_in         = $iscsi::params::node_username_in,
  $node_password_in         = $iscsi::params::node_password_in,
  $discovery_authmethod     = $iscsi::params::discovery_authmethod,
  $discovery_username       = $iscsi::params::discovery_username,
  $discovery_password       = $iscsi::params::discovery_password,
  $discovery_username_in    = $iscsi::params::discovery_username_in,
  $discovery_password_in    = $iscsi::params::discovery_password_in,
  $startup                  = $iscsi::params::startup,
  $leading_login            = $iscsi::params::leading_login,
  $replacement_timeout      = $iscsi::params::replacement_timeout,
  $login_timeout            = $iscsi::params::login_timeout,
  $logout_timeout           = $iscsi::params::logout_timeout,
  $noop_out_interval        = $iscsi::params::noop_out_interval,
  $noop_out_timeout         = $iscsi::params::noop_out_timeout,
  $abort_timeout            = $iscsi::params::abort_timeout,
  $lu_reset_timeout         = $iscsi::params::lu_reset_timeout,
  $tgt_reset_timeout        = $iscsi::params::tgt_reset_timeout,
  $initial_login_retry_max  = $iscsi::params::initial_login_retry_max,
  $session_cmds_max         = $iscsi::params::session_cmds_max,
  $session_queue_depth      = $iscsi::params::session_queue_depth,
  $xmit_thread_priority     = $iscsi::params::xmit_thread_priority,
  $initialR2T               = $iscsi::params::initialR2T,
  $immediateData            = $iscsi::params::immediateData,
  $firstBurstLength         = $iscsi::params::firstBurstLength,
  $maxBurstLength           = $iscsi::params::maxBurstLength,
  $maxRecvDataSegmentLength = $iscsi::params::maxRecvDataSegmentLength,
  $maxXmitDataSegmentLength = $iscsi::params::maxXmitDataSegmentLength,
  $headerDigest             = $iscsi::params::headerDigest,
  $dataDigest               = $iscsi::params::dataDigest,
  $nr_sessions              = $iscsi::params::nr_sessions,
  $fastAbort                = $iscsi::params::fastAbort,
  $iscsid_startup           = $iscsi::params::iscsid_startup,
  $iscsid_conf              = $iscsi::params::iscsid_conf)
inherits iscsi::params {
  class { 'iscsi::install': }

  if ($::operatingsystem == 'Windows') {
    iscsi::configurewindowsiscsiservice { 'configureIscsiWindows':
      node_authmethod          => $node_authmethod,
      node_username            => $node_username,
      node_password            => $node_password,
      node_username_in         => $node_username_in,
      node_password_in         => $node_password_in,
      discovery_authmethod     => $discovery_authmethod,
      discovery_username       => $discovery_username,
      discovery_password       => $discovery_password,
      discovery_username_in    => $discovery_username_in,
      discovery_password_in    => $discovery_password_in,
      leading_login            => $leading_login,
      replacement_timeout      => $replacement_timeout,
      login_timeout            => $login_timeout,
      logout_timeout           => $logout_timeout,
      noop_out_interval        => $noop_out_interval,
      noop_out_timeout         => $noop_out_timeout,
      abort_timeout            => $abort_timeout,
      lu_reset_timeout         => $lu_reset_timeout,
      tgt_reset_timeout        => $tgt_reset_timeout,
      initial_login_retry_max  => $initial_login_retry_max,
      session_cmds_max         => $session_cmds_max,
      session_queue_depth      => $session_queue_depth,
      xmit_thread_priority     => $xmit_thread_priority,
      initialR2T               => $initialR2T,
      immediateData            => $immediateData,
      firstBurstLength         => $firstBurstLength,
      maxBurstLength           => $maxBurstLength,
      maxRecvDataSegmentLength => $maxRecvDataSegmentLength,
      maxXmitDataSegmentLength => $maxXmitDataSegmentLength,
      headerDigest             => $headerDigest,
      dataDigest               => $dataDigest,
      nr_sessions              => $nr_sessions,
      fastAbort                => $fastAbort
    } ->
    class { 'iscsi::service': }
  } else {

    if($initiatorname != '') {
      file { '/etc/iscsi/initiatorname.iscsi':
        content => template('iscsi/initiatorname.iscsi.erb'),
        before  => File[$iscsid_conf],
        require => Class['iscsi::install'],
      }
    }

    file { $iscsid_conf:
      content => template('iscsi/iscsid.conf.erb'),
      owner   => 'root',
      group   => 'root',
      require => Class['iscsi::install'],
      notify  => Service[$iscsi::params::service],
    } ~>
    class { 'iscsi::service': }
  }
}
