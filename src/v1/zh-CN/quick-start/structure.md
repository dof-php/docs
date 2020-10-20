## Dof 完整目录树示例

``` tree
├── config    # 全局/框架配置目录
│   ├── mysql.sample.php # Storage MySQL 配置模版
│   ├── redis.sample.php    # Storage Redis 配置模版（含 sample 为的配置模版，会被版本控制；不含的为配置文件，不会被版本控制；下同）
│   ├── memcached.sample.php # Storage Memcached 配置模版
│   ├── domain.php  # 全局领域配置（会被版本控制）
│   ├── env.sample.php    # 全局环境变量配置模版
│   └── framework.php     # Dof 框架配置
├── domain    # 领域目录
│   └── User    # 某个领域目录/领域标识
│       ├── __domain__    # 领域标志目录
│       │   ├── cache.sample.php
│       │   ├── mysql.php
│       ├   │── env.sample.php    # 领域内环境变量配置模版
│       │   ├── mysql.sample.php
│       │   └── domain.php    # 领域标志文件/当前领域配置
│       ├── Assembler    # 数据组装器
│       │   └── User.php
│       ├── Command    # 领域用户自定义命令
│       │   └── User.php
│       ├── Entity    # 领域实体定义
│       │   └── User.php
│       ├── Event    # 领域事件类
│       ├── Http    # 当前领域内的 HTTP 适配目录
│       │   ├── Pipe    # 当前领域暴露的 HTTP 端口使用的管道目录
│       │   ├── Port    # 当前领域暴露的 HTTP 端口类目录
│       │   │   └── V1
│       │   │       ├── Api.php
│       │   │       ├── DoSthComplex.php
│       │   │       └── User.php
│       │   └── Wrapper    # 当前领域暴露的 HTTP 端口使用的包装器目录
│       │       └── In
│       │           ├── ABC.php
│       │           └── User.php
│       ├── Listener    # 领域事件监听者/消费者
│       ├── Repository    # 领域仓库接口目录
│       │   └── UserRepository.php
│       ├── Service    # 领域内服务目录
│       │   ├── Application    # 应用服务（用户自定义命名空间，框架没硬性要求，下同 Domain）
│       │   │   └── ShowUserService.php
│       │   └── Domain    # 领域服务
│       └── Storage    # 领域具体存储类+ORM类目录
│           └── MySQL
│               └── UserORM.php
├── var    # 动态目录，存放日志，文件缓存等
│   ├── docs-{dof-docs-type}   # 框架文档站点构建生成目录
│   ├── compile   # 框架编译文件目录 
│   │   └── {hash}.compile     # 框架编译文件名格式 
│   └── log-{php-user}   # 日志文件目录（按运行 PHP 脚本的用户名分组）
│       ├── {custom}.{sapi}.{php-user}.{process}.log   # Dof 日志文件格式
│       └── archive    # 日志文件归档目录
│           └── 2038
│               └── 01
│                   └── 19 
│                       └── {user} 
│                           └── {custom} 
│                               └── {sapi} 
│                                   └── {user}.{custom}.{sapi}.20380119-123456-7890.log
├── dof   # Dof CLI 入口文件
├── vendor
│   ├── autoload.php
│   ├── composer/...
│   ├── dof-php/framework
│   ├── ... 
├── composer.json
├── composer.lock
```

## 其他说明

- `domain` 目录

领域存放目录，示例中只有一个 `User` 领域，而实际项目中可以按业务边界放不限制数量的领域，每个领域都是一个独立的子系统，拥有独立的配置和相同而完整的目录结构。
