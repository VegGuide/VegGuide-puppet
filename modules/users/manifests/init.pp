class users {
    group { 'autarch':
        ensure => present,
        gid    => 1000,
    }

    user { 'autarch':
        ensure     => present,
        comment    => 'Dave Rolsky',
        uid        => 1000,
        gid        => 'autarch',
        shell      => '/bin/bash',
        home       => '/home/autarch',
        managehome => true,
    }

    ssh_authorized_key { 'autarch':
        ensure  => present,
        type    => 'ssh-dss',
        key     => 'AAAAB3NzaC1kc3MAAACBALW/rM+5J8mKeq4Q+fjvfDCd5CRpxzfKkdZTPCGjCZ7bp/McqxXjm6iEbYOGIGLjgd5v+QlsoB2w8r5VA7gIWFq0N24TATgoZCNYOm5dUVN8pUTXmyaR07Yz0H/JJu3JwtIpM95jXsRU3zICgEJyUMFDTVF8MzKfwUkeDaBx5jvXAAAAFQDgpRHLpHY7GbuNZQQ9L1zXU7fDxwAAAIBCZHSxTHzsXF6qOcntfx6a/+k+Uy7E6tYq7Nc6JUeNWqhvXSMkf0b0l6BCOm//oib7liB6OO37Y1jhN2kE/6tBCZiqsVZonTRQJiMn29ImRYl2t4DSgyPkNIr0LjiYjnupT1OgKyheN6QBMfmhbtbOliKOaenHXTWmKZqx3PvmzQAAAIEAmH064v2s8FHPME2h0CKhjz98CE5w117yfBbNMep5vL01c3+kSor9dhv4+hX/6yk/yzORLjuVUKzhUwJ+Fu7YeYgMsFFBwAQOcSXBudBMMGxcyxPOrAMY3a2/xaKH77gFPaKpbAN4UAG11lkmCyhwJFeGhsx2dN8JZRiOarmTuY8=',
        user    => 'autarch',
        require => User['autarch'],
        name    => 'autarch',
    }

    group { 'johnt':
        ensure => present,
        gid    => 1001,
    }

    user { 'johnt':
        ensure     => present,
        comment    => 'John Thompson',
        uid        => 1001,
        gid        => 'johnt',
        shell      => '/bin/bash',
        home       => '/home/johnt',
        managehome => true,
    }

    ssh_authorized_key { 'johnt':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDBpYSJydmsQj1ereAdhkwNndO5giYj8vNTi9uf3xXaXC8TT/Bvut8VgGp+vpYK6cY/OFCFU+jw1BSJMqP8KTaRRiVTavXCKt5ibCfP099Iw2fo4g/4Vybl3dP6Dp9zpz7o05YH2rPKtxElGhCr2TiDH6sFz1Zug+vShyTKe0IvbT2NoJIoClvroAYRysX1+F7dBn3EkOEw18UQV3CZ/9dRdmu6kleg/vJvBcCNFLFViI/i7o1sLV0o2NHQ1+CouZUL+GVkTmp0KPYpN6hCNprwJak9JujvltO2x6HAVJQaoIjmCqt/Npg0Au1BKzyEyqnKtbX54UaVGjXqAayBIfXn',
        user    => 'johnt',
        require => User['johnt'],
        name    => 'johnt',
    }
}
