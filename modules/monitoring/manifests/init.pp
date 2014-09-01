class monitoring {
    $monitoring_host = '23.239.8.38'

    package { 'nagios-nrpe-server':
        ensure => installed,
    }

    file { '/etc/nagios/nrpe_local.cfg':
        ensure  => file,
        content => template('monitoring/nrpe_local.cfg.erb'),
        require => Package['nagios-nrpe-server'],
        notify  => Service['nagios-nrpe-server'],
    }

    service { 'nagios-nrpe-server':
        ensure => running,
    }
}
