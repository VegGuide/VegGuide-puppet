class geoip {
    $geoipupdate_deb = 'geoipupdate_2.0.2-1_amd64.deb'

    file { "/opt/$geoipupdate_deb":
        ensure => file,
        source => "puppet:///modules/geoip/$geoipupdate_deb",
    }

    file { '/usr/share/GeoIP':
        ensure => directory,
    }

    package { 'geoip-bin':
        ensure   => installed,
        provider => apt,
    }

    package { 'geoipupdate':
        ensure   => installed,
        provider => dpkg,
        source   => "/opt/$geoipupdate_deb",
        require  => [
            Package['geoip-bin'],
            File["/opt/$geoipupdate_deb"],
            ],
    }

    file { 'geoipupdate-cron':
        ensure  => file,
        path    => '/etc/cron.d/geoipupdate',
        content => "27 23 * * 2 root geoipupdate -f /etc/GeoIP.conf -d /usr/share/GeoIP\n",
    }
}
