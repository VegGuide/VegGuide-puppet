Exec {
    path => [
        '/bin/',
        '/sbin/' ,
        '/usr/bin/',
        '/usr/local/bin',
        '/usr/local/sbin',
        '/usr/sbin/',
    ]
}

File {
    owner => 'root',
    group => 'root',
    mode  => 0644,
}

class common {
    include packages
    include ssh
    include timezone
    include users
    include vegguide
}

node default {
    include common

    include hostname
    include monitoring

    class {'ferm':
        monitoring_host => $monitoring::monitoring_host
    } -> Class['monitoring'] -> Class['packages'] -> Class['vegguide']
}

node 'test.vegguide.org' {
    include common

    class {'ferm':
        monitoring_host => 'NONE'
    } -> Class['packages'] -> Class['vegguide']
}
