class hostname {
    $hostname = 'vegguide.org'

    file { '/etc/hostname':
        ensure  => file,
        content => "$hostname\n",
    }

    exec { 'set-hostname':
        command => "hostname $hostname",
        unless  => "hostname | grep ^$hostname$",
    }
}
