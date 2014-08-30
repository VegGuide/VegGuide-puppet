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
    include packages
    include users
    include vegguide
}
