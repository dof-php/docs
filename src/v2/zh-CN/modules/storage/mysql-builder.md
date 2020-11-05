<!-- toc -->

如果 Storage 采用 MySQL 作为存储驱动，则可以通过 ORM 实例调用 `$this->builder()` 获取 MySQLBuilder 类实例，从而可以调用其方法构造各种 SQL 语句。

以下示例中，均使用 `$this` 代表 ORM 类实例, 使用 `$builder` 代表 MySQLBuilder 对象。

## 新增

## 删除

## 更新

## 查询

### 构造 Select 字段

### 时间处理

### 构造 Where 条件

#### 根据 ORM 类属性名获取对应的表字段名

可用于 `where` 查询时候通过类属性名而不是硬编码表字段，使得代码在表字段发生变化时无需做任何改动。

``` php
// 获取 ORM 属性 isDeleted 对应的表字段名
$column = $this->column('isDeleted');

// 将转换过的字段名用于 where 条件
$builder->where($column, 0);
```

#### `rawWhere` - 原始 SQL 作为一个 Where 条件

``` php
$builder->rawWhere("`id` % 5 = 1");

// select * from user where (id % 5 = 1);
```

#### `zero` - 判断若干个字段是否为数字 `0`

``` php
$builder->zero('is_disabled', 'is_deleted');
// select * from user where is_disabled = 0 and is_deleted = 0;
```

#### 使用闭包处理复杂查询

#### 嵌入原始 SQL 语句

### 计数

``` php
$builder-where($this->column('status', 1))->count();
```

### 分页

``` php
$page = 1;    // 分页数
$size = 10;   // 分页大小
$builder-where($this->column('status', 1))->paginate($page, $size);
```

返回一个 `DOF\Util\Paginator` 实例。

### 获取某个字段查询结果值列表

有时候我们可能只需要查询符合条件的记录中的某个字段值列表，那么可以这么用：

``` php
$builder-where($this->column('status', 1))->column('name');
```

返回符合查询条件的 `name` 字段值数组，比如：`['foo', 'bar', 'xxx', 'yyy']`。

#### 获取主键查询结果值列表

由于主键比较特殊，所以为其专门准备了一个方法来获取符合条件的主键列表：

``` php
$builder-where($this->column('status', 1))->ids();
```

返回符合查询条件的主键值数组，比如：`[1, 3, 5, 7, 9]`。

## 获取最终 SQL 语句

所有构建增删改查 SQL 语句的方法，都可以通过 `$builder->sql(true)` 来设置最终返回的是构造出来的 SQL 语句字符串而不是执行真正的 SQL。

``` php
$builder-where($this->column('status'), 1)->sql(true)->count();
```

构造的 SQL 将类似于：`select count(*) as total from user where status = 1`。