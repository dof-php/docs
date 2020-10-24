<!-- toc -->

## MySQL

### 获取自定义 MySQL 连接

``` php
use Dof\Framework\Storage\Connection;
use Dof\Framework\Storage\MySQL;

$conn = Connection::get('mysql', 'tmp', [
    'driver' => 'mysql',
    'host' => '127.0.0.1',
    'port' => 3306,
    'user' => 'root',
    'passwd' => 'root',
]);

$mysql = new MySQL;
$mysql->setConnection($conn);

$mysql->rawExec('use `user`');

pt($mysql->rawGet('show tables'));

pt($mysql->__logging());
```

### 手动事务

``` php
$storage = $this->storage();
try {
	$storage->rawExec('begin');

	// xxxx

	$storage->rawExec('commit');
} catch (Throwable) {
	$storage->rawExec('rollback');
}
```

### 动态改变 ORM 连接

``` php
$connBefore = $storage->getConnection();
$conn = \Dof\Framework\Stroage\Connection::mysql('mysql-rw-1', [
	// mysql.pool 的一个连接配置格式相同
]);
$storage->setConnection($conn);
try {
	$conn->beginTransaction();
	$conn->commit();
} catch (Throwable) {
	$conn->rollBack();
}
$storage->setConnection($connBefore);
```

## FAQ

- InvalidInsertValues-Non-Index-Array

```
[
    "CST 20191021 103657 6938",
    "menuIdsAdd",
    [
        {
            "0": {
                "menu_id": 77,
                "role_id": 63,
                "created_at": 1571625417
            },
            "13": {
                "menu_id": 78,
                "role_id": 63,
                "created_at": 1571625417
            },
            "14": {
                "menu_id": 79,
                "role_id": 63,
                "created_at": 1571625417
            },
            "15": {
                "menu_id": 80,
                "role_id": 63,
                "created_at": 1571625417
            },
            "16": {
                "menu_id": 81,
                "role_id": 63,
                "created_at": 1571625417
            },
            "17": {
                "menu_id": 82,
                "role_id": 63,
                "created_at": 1571625417
            },
            "18": {
                "menu_id": 83,
                "role_id": 63,
                "created_at": 1571625417
            }
        }
    ]
]
```

如果报这个错，则插入的数据使用 `array_values()` 重新从 0 排序下下标即可。
