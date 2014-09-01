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

node default {
    include ferm
    include monitoring
    include packages
    include users
    include vegguide

    Class['ferm'] -> Class['monitoring'] -> Class['packages'] -> Class['vegguide']
}
