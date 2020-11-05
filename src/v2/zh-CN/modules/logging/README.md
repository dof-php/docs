所有引入了 `\DOF\Traits\Tracker` 的类实例，均可以通过 `logger()` 方法获取一个通用的日志记录对象，用以写入日志。

举例说明：

``` php
$console->logger(function ($logger) {
    $logger->setPostfix('foo'); // 记录到 /var/log-USER-foo/ 目录下
})->trace('xxxx');

$console->logger()->debug('yyyy'); // 记录到 /var/log-USER/ 目录下
```

其中，`logger(\Closure $callback, bool $reset = true)` 方法可以接受一个必包参数 `$callback`，用以修改日志记录对象的属性。

第二个参数 `$reset` 默认为 `true`，表示第一个必包参数中所有对日志记录对象的修改都是临时的，只针对当前这次日志记录有效。

如果要必包函数对日志对象的设置永久生效，可以设置其为 `false`。
