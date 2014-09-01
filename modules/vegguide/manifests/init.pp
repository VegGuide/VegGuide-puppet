class vegguide {
    include perl
    include perl::version

    $perl_base_dir = "/opt/perl${perl::version::perl_version}-no-threads"
    $perl_bin_dir = "${perl_base_dir}/bin"
    $perl_site_dir = "${perl_base_dir}/lib/site_perl/${perl::version::perl_version}"

    $cpanm = "${perl_bin_dir}/cpanm --skip-satisfied"

    $vg_dir = '/opt/VegGuide-site'

    Class['perl::imagemagick'] -> Class['vegguide']

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
        command => "${cpanm} --notest Geo::IP",
        creates => "${perl_site_dir}/x86_64-linux/Geo/IP.pm",
    }

    exec { 'install-lwp-https':
        command => "${cpanm} LWP::Protocol::https",
        creates => "${perl_site_dir}/LWP/Protocol/https.pm",
    }

    exec { 'install-catalyst':
        command => "${cpanm} --notest https://cpan.metacpan.org/authors/id/J/JJ/JJNAPIORK/Catalyst-Runtime-5.90020.tar.gz",
        creates => "${perl_site_dir}/Catalyst.pm",
        require => Exec['install-lwp-https'],
    }

    exec { 'install-catalyst-unicode-plugin':
        command => "${cpanm} --notest https://cpan.metacpan.org/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Unicode-Encoding-1.9.tar.gz ",
        creates => "${perl_site_dir}/Catalyst/Plugin/Unicode/Encoding.pm",
        require => Exec['install-catalyst'],
    }

    exec { 'install-vg-prereqs':
        command => "${cpanm} `./Build modules`",
        cwd     => $vg_dir,
        timeout => 0,
        require => [
            Exec['build-vg'],
            Exec['install-catalyst-unicode-plugin'],
            Exec['install-geoip'],
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
