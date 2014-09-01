class packages {
    Package { ensure => installed, }

    package { 'build-essential': }
    package { 'debhelper': }
    package { 'devscripts': }
    package { 'emacs23-nox': }
    package { 'libdb-dev': }
    package { 'libgdbm-dev': }
    package { 'libgeoip-dev': }
    package { 'libgmp-dev': }
    package { 'libmagic-dev': }
    package { 'libmagickcore-dev': }
    package { 'libmysqlclient-dev': }
    package { 'libssl-dev': }
    package { 'mailman': }
    package { 'mysql-server': }
    package { 'nginx': }
    package { 'postfix': }
}
