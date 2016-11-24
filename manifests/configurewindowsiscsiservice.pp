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
  $initial_r2t, #
  $immediate_data, #
  $first_burst_length, #
  $max_burst_length, #
  $max_recv_data_segment_length, #
  $max_xmit_data_segment_length, #
  $header_digest,
  $data_digest,
  $nr_sessions,
  $fast_abort) {

  if ($::operatingsystem != 'Windows') {
    fail('Registry configuration for iSCSI only available on Windows')
  }

  if ($login_timeout != $logout_timeout) {
    notify { 'Windows uses a single timeout value, using that set in login_timeout': }
  }

  $root_reg_path = 'HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e97b-e325-11ce-bfc1-08002be10318}\0002\Parameters'

  registry_value { "${root_reg_path}\\DelayBetweenReconnect":
    type => dword,
    data => '',
  }

  registry_value { "${root_reg_path}\\EnableNOPOut":
    type => dword,
    data => bool2num(($noop_out_timeout > 0)),
  }

  # There should be no use cases to change this
  # registry_value { "${root_reg_path}\\ErrorRecoveryLevel":
  #  type => dword,
  #  data => ''
  #}

  registry_value { "${root_reg_path}\\FirstBurstLength":
    type => dword,
    data => $first_burst_length,
  }

  registry_value { "${root_reg_path}\\ImmediateData":
    type => dword,
    data => bool2num($immediate_data),
  }

  registry_value { "${root_reg_path}\\InitialR2T":
    type => dword,
    data => bool2num($initial_r2t),
  }

  registry_value { "${root_reg_path}\\IPSecConfigTimeout":
    type => dword,
    data => '',
  }

  registry_value { "${root_reg_path}\\LinkDownTime":
    type => dword,
    data => $replacement_timeout,
  }

  registry_value { "${root_reg_path}\\MaxBurstLength":
    type => dword,
    data => $max_burst_length,
  }

  registry_value { "${root_reg_path}\\MaxConnectionRetries":
    type => dword,
    data => '',
  }

  registry_value { "${root_reg_path}\\MaxPendingRequests":
    type => dword,
    data => $session_cmds_max,
  }

  registry_value { "${root_reg_path}\\MaxRecvDataSegmentLength":
    type => dword,
    data => $max_recv_data_segment_length,
  }

  registry_value { "${root_reg_path}\\MaxRequestHoldTime":
    type => dword,
    data => '',
  }

  registry_value { "${root_reg_path}\\MaxTransferLength":
    type => dword,
    data => $max_xmit_data_segment_length,
  }

  registry_value { "${root_reg_path}\\NetworkReadyRetryCount":
    type => dword,
    data => '',
  }

  registry_value { "${root_reg_path}\\PortalRetryCount":
    type => dword,
    data => $initial_login_retry_max,
  }

  registry_value { "${root_reg_path}\\SrbTimeoutDelta":
    type => dword,
    data => '',
  }

  registry_value { "${root_reg_path}\\TCPConnectTime":
    type => dword,
    data => '',
  }

  registry_value { "${root_reg_path}\\TCPDisconnectTime":
    type => dword,
    data => '',
  }

  registry_value { "${root_reg_path}\\WMIRequestTimeout":
    type => dword,
    data => $login_timeout,
  }
}
