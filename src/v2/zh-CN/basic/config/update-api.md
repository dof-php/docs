本文介绍如何通过命令行的方式更新某个配置项。

## 目的

实现配置注入接口的目的是为了方便部署时配置的自动化管理。

DOF 同样提供了对配置文件的操作命令行接口。

## 获取

``` shell
php dof config.get.domain http.port.route --domain=user
```

## 新增/设置

``` shell
php dof config.set.domain http.port.route api --domain=user
php dof config.set.framework ENABLE_ROUTE_CACHE 1
php dof config.set.env.domain ENABLE_ROUTE_CACHE 1 --domain=user
```

## 删除

``` shell
php dof config.unset.domain --domain=user http.port.route
```
