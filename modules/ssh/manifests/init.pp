class ssh {
    file { '/etc/ssh/sshd_config':
        ensure => file,
        source => 'puppet:///modules/ssh/sshd_config',
        notify => Service['ssh'],
    }

    service { 'ssh':
        ensure => running,
    }
}
