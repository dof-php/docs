<!-- toc -->

## PHP

- PHP >= 7.1

## Composer

使用 Composer 安装并创建 Dof 项目，假设项目名为 `app1`：

``` shell
composer clear-cache

# 安装 DOF-PHP
composer create-project dof-php/dof app1

# 更新 DOF-PHP Framework
composer update dof-php/framework --prefer-dist
```

> 若要安装开发版本（不稳定）则指定版本号为 `dev-master` 即可：composer create-project dof-php/dof=dev-master app1 --prefer-dist

## Nginx

假设我们已准备好一个本地域名 `app1.dof.dev`，Nginx 关联 Dof 的虚拟主机配置示例：

``` nginx
server {
    listen 80;
    server_name app1.dof.dev;

    index index.html index.htm index.php;
    root /data/wwwroot/app1.dof.dev/web;

    # ...

    # !!! 下面三行必须(将请求转发到 Dof web 入口文件) 否则 Nginx 会返回 404
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

## Hello World

PHP 环境设置完成后，访问 `http://app1.dof.dev`，就能看到如下返回：

``` json
{
    "Dof": "Hello, world!"
}
```

## DOF CLI

可以将 Dof 命令行入口文件复制到系统环境变量 `$PATH` 中以安装 dof cli：

``` shell
cp dof /usr/local/bin
```

然后就可以在任意路径执行 Dof 项目：

``` shell
# 在任意绝对路径执行 Dof 项目命令行
dof --set-root /path/to/dof-project version

# 在任意相对路径执行 Dof 项目命令行
dof --set-root ../../dof-project-1/ version

# 在 Dof 项目根目录执行本项目命令行
cd /path/to/dof-project
dof version

# 在 Dof 项目根目录执行其他 Dof 项目命令行
cd /path/to/dof-project
dof --set-root /path/to/dof-project-1/ version
```

## FAQ

- Composer 下载慢

请使用中国镜像，项目根目录下执行：

``` shell
composer config repo.packagist composer https://packagist.phpcomposer.com
# 或者
composer config repo.packagist composer https://packagist.laravel-china.org
```

- _Could not find a matching version of package dof-php/dof. Check the package spelling, your version constraint and that the package is available in a stability which matches your minimum-stability (dev)._

> ~dof-php 尚处于开发早期，尚未在 GitHub 发布正式版本，因此直接使用 `composer create-project dof-php/dof` 会报这个错误，指定安装 `dev-master` 的代码即可。~

> See: <https://stackoverflow.com/questions/33915523/packagist-laravel-package-composer-could-not-find-package>
