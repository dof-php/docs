- 获取自定义 MySQL 连接

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
