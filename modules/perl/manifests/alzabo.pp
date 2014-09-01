class perl::alzabo {
    include perl::version

    $perl_version = $perl::version::perl_version
    $alzabo_dir = '/opt/Alzabo-0.92'

    exec { 'download-alzabo':
        command => 'wget https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Alzabo-0.92.tar.gz',
        cwd     => '/opt',
        creates => "${alzabo_dir}.tar.gz",
        require => Class['perl'],
    }

    exec { 'untar-alzabo':
        command => "tar zxf ${alzabo_dir}.tar.gz",
        cwd     => '/opt',
        creates => $alzabo_dir,
        require => Exec['download-alzabo'],
    }

    exec { 'configure-alzabo':
        command => "/usr/local/bin/perl${perl_version} Build.PL --root /var/lib/alzabo --automated --mysql",
        cwd     => $alzabo_dir,
        creates => "${alzabo_dir}/Build",
        require => Exec['untar-alzabo'],
    }

    exec { 'install-alzabo':
        command => "/usr/local/bin/perl${perl_version} Build install",
        cwd     => $alzabo_dir,
        creates => "/opt/perl${perl_version}-no-threads/lib/site_perl/${perl_version}/Alzabo.pm",
        require => Exec['configure-alzabo'],
    }
}
