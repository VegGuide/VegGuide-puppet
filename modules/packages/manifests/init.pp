class packages {
    Package { ensure => installed, }

    package { 'build-essential': }
    package { 'emacs23-nox': }
    package { 'libmagickcore-dev': }
    package { 'mailman': }
    package { 'mysql-server': }
    package { 'nginx': }
    package { 'postfix': }
}
