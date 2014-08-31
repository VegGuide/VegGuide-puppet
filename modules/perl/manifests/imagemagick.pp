class perl::imagemagick {
    $perl_version = '5.14.4'
    $im_version = '6.77'
    $im_dir = "/opt/PerlMagick-${im_version}"

    exec { "download-imagemagick-${im_version}":
        command => "wget https://cpan.metacpan.org/authors/id/J/JC/JCRISTY/PerlMagick-${im_version}.tar.gz",
        cwd     => '/opt',
        creates => "${im_dir}.tar.gz",
        require => Class['perl'],
    }

    exec { "untar-imagemagick-${im_version}":
        command => "tar zxf PerlMagick-${im_version}.tar.gz",
        cwd     => '/opt',
        creates => $im_dir,
        require => Exec["download-imagemagick-${im_version}"],
    }

    exec { "configure-imagemagick-${im_version}":
        command => "/usr/local/bin/perl${perl_version} Makefile.PL",
        cwd     => $im_dir,
        creates => "${im_dir}/Makefile",
        require => Exec["untar-imagemagick-${im_version}"],
    }

    exec { "fixup-imagemagick-${im_version}-makefile":
        command => "perl -pi -e 's{-lperl}{-l:/opt/perl${perl_version}-no-threads/lib/${perl_version}/x86_64-linux/CORE/libperl.so}' Makefile",
        cwd     => $im_dir,
        onlyif  => "grep -- -lperl ${im_dir}/Makefile",
        require => Exec["configure-imagemagick-${im_version}"],
    }

    exec { "install-imagemagick-${im_version}":
        command => "make install",
        cwd     => $im_dir,
        creates => "/opt/perl${perl_version}-no-threads/lib/site_perl/${perl_version}/x86_64-linux/auto/Image/Magick/Magick.so",
        require => Exec["fixup-imagemagick-${im_version}-makefile"],
    }
}
