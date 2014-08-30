class packages {
    Package { ensure => installed, }

    package { 'build-essential': }
    package { 'debhelper': }
    package { 'devscripts': }
    package { 'emacs23-nox': }
    package { 'libdb-dev': }
    package { 'libgdbm-dev': }
    package { 'libmagickcore-dev': }
    package { 'mailman': }
    package { 'mysql-server': }
    package { 'nginx': }
    package { 'postfix': }
}
