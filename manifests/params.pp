# Class: iscsi::params
#
# This class manages parameters for the iscsi module
class iscsi::params {

  # By default do not set initiator
  $initiatorname            = ''

  # Auth settings
  $node_authmethod          = false
  $node_username            = false
  $node_password            = false
  $node_username_in         = false
  $node_password_in         = false
  $discovery_authmethod     = false
  $discovery_username       = false
  $discovery_password       = false
  $discovery_username_in    = false
  $discovery_password_in    = false

  # Startup settings
  $startup                  = 'manual'
  $leading_login            = false

  # Timeouts
  $replacement_timeout      = $::operatingsystem ? {
    'Windows' => 30,
    default   => 120
  }
  $login_timeout            = $::operatingsystem ? {
    'Windows' => 30,
    default   => 15
  }
  $logout_timeout           = $::operatingsystem ? {
    'Windows' => 30,
    default   => 15
  }
  $noop_out_interval        = 5
  $noop_out_timeout         = 5 # if set to zero will disable on Windows

  $abort_timeout            = 15
  $lu_reset_timeout         = 30
  $tgt_reset_timeout        = 30

  # Retry
  $initial_login_retry_max  = $::operatingsystem ? {
    'Windows' => 5,
    default   => 8
  }

  # session and device queue depth
  $session_cmds_max         = $::operatingsystem ? {
    'Windows' => 255,
    default   => 128
  }
  $session_queue_depth      = 32

  # MISC SYSTEM PERFORMANCE SETTINGS
  $xmit_thread_priority     = -20

  # iSCSI settings
  $initialR2T               = false
  $immediateData            = true
  $firstBurstLength         = $::operatingsystem ? {
    'Windows' => 65536,
    default   => 262144
  }
  $maxBurstLength           = $::operatingsystem ? {
    'Windows' => 262144,
    default   => 16776192
  }
  $maxRecvDataSegmentLength = $::operatingsystem ? {
    'Windows' => 65536,
    default   => 262144
  }
  $maxXmitDataSegmentLength = $::operatingsystem ? {
    'Windows' => 262144,
    default   => 0
  }
  $headerDigest             = 'None'
  $dataDigest               = 'None'
  $nr_sessions              = 1

  # Workarounds
  $fastAbort                = true

  $iscsid_conf              = '/etc/iscsi/iscsid.conf'

  case $::osfamily {
    debian  : {
      $packages         = 'open-iscsi'
      $service          = 'open-iscsi'
      $iscsid_startup   = '/usr/sbin/iscsid'
      $package_provider = 'apt'
      $exec_provider    = 'posix'
    }

    redhat  : {
      $packages         = 'iscsi-initiator-utils'
      $service          = 'iscsid'
      $iscsid_startup   = '/etc/rc.d/init.d/iscsid force-start'
      $package_provider = 'apt'
      $exec_provider    = 'posix'
    }

    windows : {
      $packages         = undef
      $service          = 'msiscsi'
      $iscsid_startup   = 'Restart-Service msiscsi -Force'
      $package_provider = 'chocolatey'
      $exec_provider    = 'powershell'
    }

    default : {
      fail('ISCSI only works on Debian or Redhat families of Linux or with Windows.')
    }
  }
}
