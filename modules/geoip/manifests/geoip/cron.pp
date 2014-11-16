class geoip::cron {
    file { 'geoipupdate-cron':
        ensure  => file,
        path    => '/etc/cron.d/geoipupdate',
        content => "27 23 * * 2 root geoipupdate -f /etc/GeoIP.conf -d /usr/share/GeoIP\n",
    }
}
