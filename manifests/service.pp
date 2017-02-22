# Class: iscsi::service
#
# This class manages the service for the iscsi module
class iscsi::service () {

  $_enable = $::operatingsystem ? {
    'Windows' => $iscsi::initiator::iscsid_startup ? {
      'manual' => false,
      default  => true
    },
    default   => $iscsi::initiator::iscsid_startup ? {
      'manual' => false,
      default  => true
    },
  }

  service { $iscsi::params::service:
    ensure     => 'running',
    hasrestart => true,
    enable     => $_enable,
  }
}
