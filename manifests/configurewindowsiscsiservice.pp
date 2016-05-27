define iscsi::configurewindowsiscsiservice (
  $node_authmethod,
  $node_username,
  $node_password,
  $node_username_in,
  $node_password_in,
  $discovery_authmethod,
  $discovery_username,
  $discovery_password,
  $discovery_username_in,
  $discovery_password_in,
  $leading_login,
  $replacement_timeout, #
  $login_timeout, #
  $logout_timeout, #
  $noop_out_interval,
  $noop_out_timeout,
  $abort_timeout,
  $lu_reset_timeout,
  $tgt_reset_timeout,
  $initial_login_retry_max,
  $session_cmds_max,
  $session_queue_depth,
  $xmit_thread_priority,
  $initialR2T, #
  $immediateData, #
  $firstBurstLength, #
  $maxBurstLength, #
  $maxRecvDataSegmentLength, #
  $maxXmitDataSegmentLength, #
  $headerDigest,
  $dataDigest,
  $nr_sessions,
  $fastAbort) {
  if ($operatingsystem != 'Windows') {
    fail("Registry configuration for iSCSI only available on Windows")
  }

  if ($login_timeout != $logout_timeout) {
    notify { "Windows uses a single timeout value, using that set in login_timeout": }
  }

  $rootRegPath = 'HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e97b-e325-11ce-bfc1-08002be10318}\0002\Parameters'

  registry_value { "${rootRegPath}\\DelayBetweenReconnect":
    type => dword,
    data => ''
  }

  registry_value { "${rootRegPath}\\EnableNOPOut":
    type => dword,
    data => bool2num(($noop_out_timeout > 0))
  }

  # There should be no use cases to change this
  # registry_value { "${rootRegPath}\\ErrorRecoveryLevel":
  #  type => dword,
  #  data => ''
  #}

  registry_value { "${rootRegPath}\\FirstBurstLength":
    type => dword,
    data => $firstBurstLength
  }

  registry_value { "${rootRegPath}\\ImmediateData":
    type => dword,
    data => bool2num($immediateData)
  }

  registry_value { "${rootRegPath}\\InitialR2T":
    type => dword,
    data => bool2num($initialR2T)
  }

  registry_value { "${rootRegPath}\\IPSecConfigTimeout":
    type => dword,
    data => ''
  }

  registry_value { "${rootRegPath}\\LinkDownTime":
    type => dword,
    data => $replacement_timeout
  }

  registry_value { "${rootRegPath}\\MaxBurstLength":
    type => dword,
    data => $maxBurstLength
  }

  registry_value { "${rootRegPath}\\MaxConnectionRetries":
    type => dword,
    data => ''
  }

  registry_value { "${rootRegPath}\\MaxPendingRequests":
    type => dword,
    data => $session_cmds_max
  }

  registry_value { "${rootRegPath}\\MaxRecvDataSegmentLength":
    type => dword,
    data => $maxRecvDataSegmentLength
  }

  registry_value { "${rootRegPath}\\MaxRequestHoldTime":
    type => dword,
    data => ''
  }

  registry_value { "${rootRegPath}\\MaxTransferLength":
    type => dword,
    data => $maxXmitDataSegmentLength
  }

  registry_value { "${rootRegPath}\\NetworkReadyRetryCount":
    type => dword,
    data => ''
  }

  registry_value { "${rootRegPath}\\PortalRetryCount":
    type => dword,
    data => $initial_login_retry_max
  }

  registry_value { "${rootRegPath}\\SrbTimeoutDelta":
    type => dword,
    data => ''
  }

  registry_value { "${rootRegPath}\\TCPConnectTime":
    type => dword,
    data => ''
  }

  registry_value { "${rootRegPath}\\TCPDisconnectTime":
    type => dword,
    data => ''
  }

  registry_value { "${rootRegPath}\\WMIRequestTimeout":
    type => dword,
    data => $login_timeout
  }
}
