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
    include ferm
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

    Class['ferm'] -> Class['monitoring'] -> Class['packages'] -> Class['vegguide']
}

node 'test.vegguide.org' {
    include common

    Class['ferm'] -> Class['packages'] -> Class['vegguide']
}
