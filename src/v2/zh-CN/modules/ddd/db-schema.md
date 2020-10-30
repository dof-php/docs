<!-- toc -->

本章介绍 DOF 可以自动化的一些流程。

数据库 Schema 版本控制，可在部署时候自动执行数据库结构的同步操作。

DOF 同样是通过注解的形式来定义我们的 ORM 类文件，在定义 ORM 的同时即可定义我们的数据库 Schema。

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

declare(strict_types=1);

namespace Domain\User\Storage\MySQL;

use DOF\Framework\DDD\ORMStorage;
use Domain\User\Repository\UserRepository;

/**
 * @Repository(UserRepository)
 * @Driver(mysql)
 * @Database(demo)
 * @Table(user)
 * @Index(idx_mobile){mobile}
 * @Comment(User Table)
 */
class UserORM extends ORMStorage implements UserRepository
{
    /**
     * @Column(nickname)
     * @Type(varchar)
     * @Length(16)
     * @Comment(User Nickname)
     */
    private $nickname;

    /**
     * @Column(mobile)
     * @Type(varchar)
     * @Length(11)
     * @Comment(User Mobile)
     */
    private $mobile;
}
{%endace%}

然后执行也只需要执行一条命令：

``` shell
php dof orm.sync
```

这条命令会总的来说完成以下几件事情：

- 扫描领域中所有有效的 ORM 类文件。
- 自动检查数据库、表是否存在，不存在则按照 ORM 类定义和注解自动创建。
- 自动检查数据库中表的字段、索引和 ORM 类定义是否一致，不一致则自动同步到数据库。

通过以上说明可以发现，DOF 中数据库 Schema 的版本控制实则是和代码（ORM 类文件）的版本控制一起的！

## `orm.sync`

### 命令选项

#### domain

只同步某个领域的 ORM 类文件，参数值接受领域的代号，即领域目录名的小写形式。

``` shell
php dof orm.sync --domain=user
```

#### single

只同步某一个 ORM 类文件，参数值接受一个 ORM 类文件的路径，既可以是相对于项目根目录的相对路径，也可以是绝对路径。

``` shell
php dof orm.sync --single=domain/User/Storage/MySQL/UserORM.php
```

#### skip

同步时跳过部分 ORM 类文件，值要求是 ORM 类文件的路径，多个 ORM 类文件之间使用英文逗号 `,` 隔开。

``` shell
php dof orm.sync --skip=domain/User/Storage/MySQL/UserORM.php,domain/ABC/Storage/MySQL/ABCORM.php
```

#### dump

打印如何执行数据库 Schema 同步操作将会执行的 SQL 语句，可以结合其他选项一起使用。

``` shell
php dof orm.sync --dump --force
```

输出的 SQL 语句会按 ORM 类文件分隔。

#### force

强制执行所有删除型操作，包括删除表字段、索引。**应用该选项的时候一定要清醒**。

## `orm.init`

初始化某个 ORM 类文件定义的 Schema 到数据库。

该命令只有三个选项：

- `--force`：和 `orm.sync` 一样。
- `--dump`：和 `orm.sync` 一样。
- `--orm`：要初始化 ORM 类文件命名空间或者文件路径。

## 生产实践

### ALTER

由于同步数据库 Schema 操作可能包含 `ALTER` 语句，在表数据量较大且该表有关的业务高峰期时尽量避免执行 `orm.sync` 命令，否则将会锁表影响线上业务的正常运行。

> 这个不是数据库 Schema 版本控制设计本身的问题，这属于 RDBMS 自身的问题。

### DROP

数据是项目的核心。

因此，`orm.sync` 命令默认情况下是不会执行 `DROP` 相关语句，但是该命令提供一个选项 `force`，在你清醒的知道你要干什么的前提下，可以使用该选项强制执行物理删除操作。

``` shell
# !!! 强制执行所有删除相关操作
php dof orm.sync --force
```

## Q&A

### 什么是有效的 ORM 类文件？

- 继承了 `DOF\Framework\DDD\ORMStorage`。

> 也可以继承 `DOF\Framework\DDD\ORMStorageWithTS`, `DOF\Framework\DDD\ORMStorageWithTSSD`, `DOF\Framework\DDD\ORMStorageWithSD` 这三个继承了 `DOF\Framework\DDD\ORMStorage` 的类。

- 类文件名在领域根目录的 `Storage` 目录下（包括无限子目录）。
- 类文件名必须以 `ORM.php` 结束，比如 `UserORM.php`。

### 如何追踪一个表的结构变动历史?

在 DOF 中，如果要追踪一个表结构的变更记录，则只需要追踪这个表对应的 ORM 类文件在代码版本控制系统的变更记录即可。

### 和 Laravel Migration 的对比

使用过 Laravel 的同学应该知道 Migration 这个组件，它是一种用来数据库版本控制的手段，要使用 Migration，你至少得进行如下操作：

- 安装 DBAL 依赖包
- 初始化一个存储 Migration 元数据的表
- 创建迁移类文件
- 定义迁移类 Schema
- 执行迁移命令行

此外，Laravel Migration 还提供了一些 commit, rollback, reset, refresh, fresh 等命令行支持等等，总的来说非常完善和方便。

DOF 设计的数据库 Schema 版本控制的思路和 Migration 完全不同，它的使用更加简单直接，不需要借助多余的外部存储，也没有任何包依赖，用户只需要记住一条命令即可完成数据库结构的自动同步操作。
