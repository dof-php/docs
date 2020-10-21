<!-- toc -->

由于 2.x 将框架代码按功能模块化了，因此也相应重新规划了 DOF 项目目录结构。

在最极简模式下，DOF 2.x 项目可以只有一个 `composer.json` 文件。

## 基本目录结构

2.x DOF 项目顶级目录命名基本准守 UNIX-like 风格：

### src

领域存放目录。实际项目中可以按业务边界放不限制数量的领域，每个领域都是一个独立的子系统，拥有独立的配置管理和相同而完整的目录结构。

```
src    # 领域目录
└── User    # 某个领域目录/领域标识
    ├── Err.php    # 领域自定义错误文件
    ├── __domain__.php    # 领域标志文件/领域元数据配置文件
    ├── Assembler    # 数据组装器
    │   └── User.php
    ├── Command    # 领域用户自定义命令
    │   └── User.php
    ├── Entity    # 领域实体定义
    │   └── User.php
    ├── Event    # 领域事件类
    ├── HTTP    # 当前领域内的 HTTP 适配目录
    │   ├── Pipe    # 当前领域暴露的 HTTP 端口使用的管道目录
    │   ├── Port    # 当前领域暴露的 HTTP 端口类目录
    │   │   └── V1
    │   │       ├── Api.php
    │   │       ├── DoSthComplex.php
    │   │       └── User.php
    │   └── Wrapper    # 当前领域暴露的 HTTP 端口使用的包装器目录
    │       └── In
    │           ├── ABC.php
    │           └── User.php
    ├── Listener    # 领域事件监听者/消费者
    ├── Repository    # 领域仓库接口目录
    │   └── UserRepository.php
    ├── Service    # 领域内服务目录
    │   ├── Application    # 应用服务（用户自定义命名空间，框架没硬性要求，下同 Domain）
    │   │   └── ShowUserService.php
    │   └── Domain    # 领域服务
    └── Storage    # 领域具体存储类+ORM类目录
        └── MySQL
            └── UserORM.php
```

### etc

私有配置、环境变量配置存放目录，会被 `\ETC` 类自动读取。需要被版本控制所排除。

`etc` 目录里面的文件为系统/框架/领域默认私有配置。

`etc` 目录下的 `domain` 目录为领域专有私有配置目录，其下的目录为领域同名目录，存放有私有配置需求的领域配置。

其中 `env.php` 比较特殊，会被 `\ENV` 自动读取。

```
/etc/
	/env.php
	/mysql.php
	/redis.php
	/domain/
		/User/
			/env.php
			/mysql.php
			/redis.php
		/Order/
			/env.php
			/mysql.php
			/redis.php
	/vendor/
		/dof-php/
			/utils/
				/env.php
```

### var

动态目录。存放编译文件、文件缓存、文件日志、上传临时文件等。

```
var
├── cache      # 文件缓存 
├── compile    # 各种编译文件(Manager/项目配置) 存储目录
└── log-{php-user}
    └── {custom}.{sapi}.{php-user}.{process}.log   # DOF 日志文件格式
    └── archive    # 日志文件归档目录
        └── 2038
            └── 01
                └── 19 
                    └── {user} 
                        └── {custom} 
                            └── {sapi} 
                                └── {user}.{custom}.{sapi}.20380119-123456-7890.log
```

### www

网站根目录；存放 PHP-FPM 运行模式下的 HTTP 入口引导文件 `index.php`、公开访问的静态资源等。

说明：该目录由 `dof-php/http` 模块自动创建。

### ini

系统/框架初始化参数/全局领域配置等，会被 `\INI` 类自动读取。其下代码需要放在版本控制中。

```
ini
└── addons
    └── dof-php
        ├── ddd
        │   └── cmd.php    # ddd 模块的命令行配置文件, CommandManager 主动读取该配置文件（下同）
        ├── http
        │   └── cmd.php    # http 模块的命令行配置文件
        └── utils
            └── cmd.php    # utils 模块的命令行配置文件
```

### boot

模块启动文件存放目录，里面的代码会在框架初始化之后依次被执行，里面的代码主要是各种 Manager 的初始化操作和顶级类命名空间别名定义。

```
boot
└── addons
    └── dof-php
        ├── ddd
        │   └── boot.php    # ddd 模块的启动文件
        ├── http
        │   └── boot.php    # http 模块的启动文件
        └── utils
            └── boot.php    # utils 模块的启动文件
```

### gwt

GWT 测试用例存放目录。可按领域分子目录存放各自领域的测试用例。

### lang

多语言配置文件存放目录。

## DOF 2.x 项目目录树示例

``` tree
```
