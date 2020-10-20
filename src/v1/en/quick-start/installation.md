<!-- toc -->

## PHP

- PHP >= 7.1

## Composer

Use Composer to install and create Dof project，assume project name is `app1`：

``` shell
composer clear-cache
composer create-project dof-php/dof=dev-master app1 --prefer-dist
```

## Nginx

To associate Nginx and Dof，the vhost config example：

``` nginx
server {
    listen 80;
    server_name app1.dof.dev;

    index index.html index.htm index.php;
    root /data/wwwroot/app1.dof.dev/web;

    # ...

    # !!! Below three lines are required (Redirect http request to Dof web entry)
    # !!! Or Nginx will return 404
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ [^/]\.php(/|$) {
        #fastcgi_pass remote_php_ip:9000;
        fastcgi_pass unix:/dev/shm/php-cgi.sock;
        fastcgi_index index.php;
        include fastcgi.conf;
    }

    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|flv|mp4|ico)$ {
        expires 30d;
        access_log off;
    }
    location ~ .*\.(js|css)?$ {
        expires 7d;
        access_log off;
    }
    location ~ /\.ht {
        deny all;
    }

    # ...
}
```

## FAQ

- _Could not find a matching version of package dof-php/dof. Check the package spelling, your version constraint and that the package is available in a stability which matches your minimum-stability (dev)._


Dof is in its early development stage，and not release any production version at GitHub yet，and using `composer create-project dof-php/dof` to install Dof will raise this error，so here we just using the exactly version of code of `dev-master`。

> See: <https://stackoverflow.com/questions/33915523/packagist-laravel-package-composer-could-not-find-package>
