# Class: iscsi::service
#
# This class manages the service for the iscsi module
class iscsi::service () inherits iscsi::params {

  $_enable = $::operatingsystem ? {
    'Windows' => $iscsi::params::startup ? {
      'manual' => false,
      default  => true
    },
    default   => false
  }

  service { $iscsi::params::service:
    ensure     => 'running',
    hasrestart => true,
    enable     => $_enable,
  }
}
