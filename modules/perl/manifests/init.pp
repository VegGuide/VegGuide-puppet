class perl {
    $version = '5.14.4'
    $repo = 'modern-perl-deb'
    $repo_url = "git://git.urth.org/$repo"
    $deb = "/opt/$repo/perl-$version-no-threads_$version-1_amd64.deb"

    package { 'git':
        ensure => installed,
    }

    vcsrepo { $repo:
        ensure   => present,
        path     => "/opt/$repo",
        provider => git,
        source   => $repo_url,
        require  => Package['git'],
    }

    exec { "build-$version-deb":
        command => 'debuild -i -us -uc -b',
        cwd     => "/opt/$repo/perl-$version",
        timeout => 1800,
        creates => $deb,
        require => [ Class['packages'], Vcsrepo[$repo], ],
    }

    package { "perl-$version-no-threads":
        ensure   => installed,
        provider => dpkg,
        source   => $deb,
        require  => Exec["build-$version-deb"],
    }

    file { [ '/root/.cpan', '/root/.cpan/CPAN' ]:
        ensure => directory,
    }

    file { '/root/.cpan/MyConfig.pm':
        ensure => file,
        source => 'puppet:///modules/perl/MyConfig.pm',
    }

    exec { 'install-cpanm':
        command => "/opt/perl$version-no-threads/bin/cpan App::cpanminus",
        require => File['/root/.cpan/MyConfig.pm'],
        creates => "/opt/perl$version-no-threads/bin/cpanm",
    }
}
