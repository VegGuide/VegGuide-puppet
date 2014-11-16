class ferm ($monitoring_host) {
    package { 'ferm':
        ensure => installed,
    }

    file { '/etc/ferm/ferm.conf':
        ensure  => file,
        content => template('ferm/ferm.conf.erb'),
        require => Package['ferm'],
        notify  => Service['ferm'],
    }

    service { 'ferm':
        enable     => true,
        hasstatus  => false,
        status     => '/bin/true',
        hasrestart => false,
        restart    => 'service ferm reload',
        require    => Package['ferm'],
    }
}
