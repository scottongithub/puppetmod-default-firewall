class default_firewall::pre {
  Firewall {
    require => undef,
  }

$management_source_ip = lookup(default_settings::management_source_ip)

  # Default firewall rules
  firewall { '000 accept all icmp':
    proto  => 'icmp',
    action => 'accept',
  }
  -> firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }
  -> firewall { '002 reject local traffic not on loopback interface':
    iniface     => '! lo',
    proto       => 'all',
    destination => '127.0.0.1/8',
    action      => 'reject',
  }
  -> firewall { '003 accept inbound SSH':
    dport  => 22,
    source => $management_source_ip,
    action => 'accept',
  }
  -> firewall { '004 accept related established rules':
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }
}
