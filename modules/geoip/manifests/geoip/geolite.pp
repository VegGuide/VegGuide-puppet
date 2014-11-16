class geoip::geolite {
    exec { 'download-geolite-city':
        command => 'wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz',
        cwd     => '/tmp',
        creates => '/tmp/GeoLiteCity.dat.gz',
    }

    exec { 'unzip-geolite':
        command => 'gunzip GeoLiteCity.dat.gz',
        cwd     => '/tmp',
        creates => '/tmp/GeoLiteCity.dat',
        require => Exec['download-geolite-city'],
    }

    file { 'geolite-city':
        ensure  => file,
        path    => '/usr/share/GeoIP/GeoIP.dat',
        source  => 'file:///tmp/GeoLiteCity.dat',
        require => [
            Exec['unzip-geolite'],
            File['/usr/share/GeoIP'],
            ],
    }
}
