<!-- toc -->

本文介绍如何在 Dof 读取各种配置。

## 代码读取配置

### 读取领域内配置

``` php
// 读取当前命名空间所在领域的环境变量配置
domain()->env('AB_CD');
// 读取当前命名空间所在领域的领域配置
domain()->domain('ab.cd');
// 读取当前命名空间所在领域的任意文件名中的配置
domain()->config('mysql', 'default');

// 读取某个指定领域的环境变量配置 - 按领域 KEY
domain('User')->env('AB_CD');
// 读取某个指定领域的领域配置 - 按领域 KEY
domain('User')->domain('ab.cd');
// 读取当前命名空间所在领域的任意文件名中的配置 - 按领域 KEY
domain()->config('mysql', 'default');

// 读取某个指定领域的环境变量配置 - 按领域命名空间
domain(\Domain\User\Service\Action::class)->env('AB_CD');
// 读取某个指定领域的领域配置 - 按领域命名空间
domain(\Domain\User\Service\Action::class)->domain('ab.cd');
// 读取当前命名空间所在领域的任意文件名中的配置 - 按领域命名空间
domain(\Domain\User\Service\Action::class)->config('mysql', 'default');

// 读取某个指定领域的环境变量配置 - 按领域文件路径
domain(pathof('Domain/User/Service/Action.php'))->env('AB_CD');
// 读取某个指定领域的领域配置 - 按领域文件路径
domain(pathof('Domain/User/Service/Action.php'))->domain('ab.cd');
// 读取当前命名空间所在领域的任意文件名中的配置 - 按领域文件路径
domain(pathof('Domain/User/Service/Action.php'))->config('mysql', 'default');
```

### 读取全局配置

``` php
config('env', 'AB_CD');
config('domain', 'ab.cd');
config('mysql', 'default');
config('framework', 'xxx.yyy.zzz');
```

### 通用读取

前面的，不管是通过 `domain()` 函数还是 `config()` 函数，其实都是对 Dof 框架的配置管理类方法调用的封装，因此你也可以直接通过框架的配置管理类的接口来获取任意类型的配置。

``` php
// 获取全局领域配置
ConfigManager::getDomain('ab.cd', 1);

// 读取某个指定领域的领域配置 - 按领域命名空间
ConfigManager::getDomainDomainByNamespace(\Domain\User\Service\Action::class, 'ab.cd', 1);

// 读取某个指定领域的领域配置 - 按领域 KEY
ConfigManager::getDomainByKey('User', 'ab.cd', 1);

// 读取某个指定领域和全局领域配置某个配置项的并集
ConfigManager::getDomainMergeDomainByNamespace(\Domain\User\Service\Action::class, 'ab.cd', 1);
```

> 更多获取配置的方法查看类 `Dof\Framework\ConfigManager` 的方法声明。

## 命令行读取配置值

一些可能外部命令可能需要和 Dof 项目的配置项发生交互，以了解项目当前的配置情况，因此 Dof 对外也暴露了命令行接口以方便外部工具/脚本获取。

- `config.get.domain`：获取领域配置。

``` shell
# 获取全部的领域配置
dof config.get.domain

# 获取 abcd 领域的所有配置
dof config.get.domain --domain=abcd

# 获取 abcd 领域的配置项 e.f.g.h
dof config.get.domain --domain=abcd e.f.g.h

# 获取 abcd 领域的配置项 e.f.g.h 并以纯 ASCII 文本的格式输出
dof config.get.domain --domain=abcd e.f.g.h --ascii
```

- `config.get.framework`：获取框架有关配置。

``` shell
# 获取全部的框架配置
dof config.get.framework

# 获取框架配置项 e.f.g.h
dof config.get.framework e.f.g.h

# 获取框架配置项 e.f.g.h 并以纯 ASCII 文本的格式输出
dof config.get.framework e.f.g.h --ascii
```

- `config.get.global`：获取跨领域全局配置。

``` shell
# 获取全部的全局配置
dof config.get.global

# 获取全局配置项 e.f.g.h
dof config.get.global e.f.g.h

# 获取全局配置项 e.f.g.h 并以纯 ASCII 文本的格式输出
dof config.get.global e.f.g.h --ascii
```

### 链式配置 KEY 说明

通过命令行获取项目某个 KEY 的配置值时候，可以链式调用。以上面例子中的 KEY `e.f.g.h` 继续举例说明，按照获取的先后顺序，以下几种情况都能通过配置项 KEY `e.f.g.h` 拿到：

``` php
'e.f.g.h' => 'val',

'e' => [
    'f.g.h' => 'val',
],

'e' => [
    'f' => [
        'g.h' => 'val',
    ],
],

'e' => [
    'f' => [
        'g' => [
            'h' => 'val'
        ],
    ],
],
```

> 规律是以 `.` 为 KEY 分隔符，从第一个元素开始找，找到第一个把第一个排外之后的剩余元素作为新 KEY，重复这个操作递归查找。
