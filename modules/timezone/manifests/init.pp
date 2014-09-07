class timezone {
    file { '/etc/timezone':
        ensure  => file,
        content => "America/Denver\n",
    }

    file { '/etc/localtime':
        ensure => link,
        target => '/usr/share/zoneinfo/America/Denver',
    }
}
