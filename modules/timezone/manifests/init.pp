class timezone {
    file { '/etc/timezone':
        ensure  => file,
        content => "America/Denver\n",
    }
}
