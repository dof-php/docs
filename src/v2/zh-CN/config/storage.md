<!-- toc -->

本文介绍如何配置存储驱动。

## MySQL

全局配置文件 `config/mysql.php`，或者领域内配置文件 `__domain__/mysql.php`

``` php
<?php

return [
    'default' => 'mysql57-rw',

    'pool' => [
        'mysql57-rw' => [
            'driver' => 'mysql',
            'host' => '127.0.0.1',
            'port' => 3306,
            'user' => 'user',
            'passwd' => 'pswd',
        ],
    ],

    'master' => [
        'mysql57-rw-1',
        'mysql57-rw-2',
    ],

    'slave' => [
        'mysql57-ro-1',
        'mysql57-ro-2',
    ],

    'rw' => [
        'mysql57-rw',
    ],

    'ro' => [
        'mysql57-ro-1',
        'mysql57-ro-2',
    ],

    'wo' => [
        'mysql57-wo-1',
        'mysql57-wo-2',
    ],
];
```

## Redis

全局配置文件 `config/redis.php`，或者领域内配置文件 `__domain__/redis.php`

``` php
<?php

return [
    'default' => 'local-4.0',

    'pool' => [
        'local-4.0' => [
            'host' => '127.0.0.1',
            'auth' => false,
            'password' => '',
        ],
    ],
];
```

## Memcached 

全局配置文件 `config/memcached.php`，或者领域内配置文件 `__domain__/memcached.php`

``` php
<?php

return [
    'default' => 'mem1.5',

    'pool' => [
        'mem1.5' => [
            'host'   => '127.0.0.1',
            'port'   => 11211,
            'weight' => 1,
            'sasl_auth' => false,
            'sasl_user' => '',
            // 'persistent_id' => null,
            // 'libketama_compatible' => false,
            // 'tcp_nodelay' => true,
            // 'compression' => false,
            // 'binary_protocol' => true,
            'sasl_pswd' => '',
        ],

        'user-0' => [
            'host'   => '',
            'port'   => 11211,
            'weight' => 1,
        ],

        // ...
    ],

    'group' => [
        'default' => [
            'mem1.5',
        ],
        'user' => [
            'user-0',
        ],
    ],

    'cache' => [
        'mem1.5',
        'user-0',
    ],
];
```
