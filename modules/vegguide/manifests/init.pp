class vegguide {
    include perl
    include perl::version
    include geoip

    $perl_base_dir = "/opt/perl${perl::version::perl_version}-no-threads"
    $perl_bin_dir = "${perl_base_dir}/bin"
    $perl_site_dir = "${perl_base_dir}/lib/site_perl/${perl::version::perl_version}"

    $cpanm = "${perl_bin_dir}/cpanm --notest --skip-satisfied"

    $vg_dir = '/opt/VegGuide-site'

    Class['perl::imagemagick'] -> Class['vegguide']
    Class['perl::alzabo'] -> Class['vegguide']

    file { '/etc/nginx/sites-enabled/default':
        ensure => absent,
    }

    file { 'apply-puppet':
        ensure => file,
        path   => '/usr/local/bin/apply-puppet',
        source => 'puppet:///modules/vegguide/apply-puppet',
        mode   => '0755',
    }

    vcsrepo { 'VegGuide-site':
        ensure   => present,
        path     => $vg_dir,
        provider => git,
        source   => 'https://github.com/VegGuide/VegGuide-site.git',
    }

    exec { 'build-vg':
        command => "${perl_bin_dir}/perl ./Build.PL",
        cwd     => $vg_dir,
        creates => "${vg_dir}/Build",
        require => Vcsrepo['VegGuide-site'],
    }

    exec { 'install-geoip':
        command => "${cpanm} Geo::IP",
        creates => "${perl_site_dir}/x86_64-linux/Geo/IP.pm",
    }

    exec { 'install-lwp-https':
        command => "${cpanm} LWP::Protocol::https",
        creates => "${perl_site_dir}/LWP/Protocol/https.pm",
    }

    exec { 'install-catalyst':
        command => "${cpanm} https://cpan.metacpan.org/authors/id/J/JJ/JJNAPIORK/Catalyst-Runtime-5.90075.tar.gz",
        creates => "${perl_site_dir}/Catalyst.pm",
        require => Exec['install-lwp-https'],
    }

    exec { 'install-catalyst-session':
        command => "${cpanm} https://cpan.metacpan.org/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Session-0.37.tar.gz",
        creates => "${perl_site_dir}/Catalyst/Plugin/Session.pm",
        require => Exec['install-catalyst'],
    }

    exec { 'install-locale-country':
        command => "${perl_bin_dir}/cpanm --notest Locale::Country",
    }

    exec { 'install-catalyst-view-mason':
        command => "${cpanm} Catalyst::View::Mason",
        creates => "${perl_site_dir}/Catalyst/View/Mason.pm",
    }

    exec { 'install-vg-prereqs':
        command => "${cpanm} `./Build modules`",
        cwd     => $vg_dir,
        timeout => 0,
        creates => "${perl_site_dir}/XML/SAX/Writer.pm",
        require => [
            Exec['build-vg'],
            Exec['install-catalyst-unicode-plugin'],
            Exec['install-geoip'],
            Exec['install-locale-country'],
            ],
    }

    exec { 'install-vg':
        command => "${vg_dir}/Build install",
        cwd     => $vg_dir,
        timeout => 0,
        creates => '/etc/nginx/sites-available/vegguide.org',
        require => Exec['install-vg-prereqs'],
    }
}
