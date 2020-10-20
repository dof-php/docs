<!-- toc -->

## 实现守护进程的几种方式

### 使用 swoole server 的 `set()` 方法

``` php
$server->set([
    'daemonize' => true, 
]);
```

> https://wiki.swoole.com/wiki/page/278.html

### 使用 systemd

```
[Unit]
Description=Echo Http Server
After=network.target
After=syslog.target

[Service]
Type=simple
LimitNOFILE=65535
ExecStart=/usr/bin/php /opt/servers/echo/server.php
ExecReload=/bin/kill -USR1 $MAINPID
Restart=always

[Install]
WantedBy=multi-user.target graphical.target
```

``` shell
sudo systemctl --system daemon-reload

sudo systemctl status echo.service
sudo systemctl start echo.service
sudo systemctl reload echo.service
sudo systemctl stop echo.service
```

> https://wiki.swoole.com/wiki/page/699.html

### 使用 nohup

一般 Server 程序都是运行在系统后台，这与普通的交互式命令行程序有很大的区别。glibc 里有一个函数 daemon。调用此函数，就可使当前进程脱离终端变成一个守护进程，具体内容参见 `man daemon`。

PHP 中暂时没有此函数，当然如果你有兴趣的话，可以写一个 PHP 的扩展函数来实现。

```
nohup php server.php > log.txt &
```

单独执行 `php myprog.php`，当按下 ctrl+c 时就会中断程序执行，会 kill 当前进程以及子进程。

`php myprog.php &`，这样执行程序虽然也是转为后台运行，实际上是依赖终端的，当用户退出终端时进程就会被杀掉。

### 使用 PHP 进程管理

``` php
function daemonize()
{
    $pid = pcntl_fork();
    if ($pid == -1) {
        die("fork(1) failed!\n");
    } elseif ($pid > 0) {
        // 让由用户启动的进程退出
        exit(0);
    }

    // 建立一个有别于终端的新session以脱离终端
    posix_setsid();

    $pid = pcntl_fork();
    if ($pid == -1) {
        die("fork(2) failed!\n");
    } elseif ($pid > 0) {
        // 父进程退出, 剩下子进程成为最终的独立进程
        exit(0);
    }
}

daemonize();
sleep(1000);
```

用上面代码即可实现守护进程化，当你的PHP程序需要转为后台运行时，只需要调用一次封装好的函数daemonize()即可。
注：这里没有实现标准输入输出的重定向。

> http://rango.swoole.com/archives/59


## 平滑重启

对于线上繁忙的 server，如果你直接把守护进程化的 server 干掉了，就很有可能某个进程刚好就只处理了一半的数据从而导致数据异常。

所谓的平滑重启，也叫“热重启”，就是在不影响用户的情况下重启服务，更新内存中已经加载的 php 程序代码，从而达到对业务逻辑的更新。

swoole 为我们提供了平滑重启机制，我们只需要向 swoole_server 的主进程发送特定的信号，即可完成对 server 的重启。

信号是软件中断，每一个信号都有一个名字。通常，信号的名字都以“SIG”开头，比如我们最熟悉的Ctrl+C就是一个名字叫“SIGINT”的信号，意味着“终端中断”。

在 swoole 中，我们可以向主进程发送各种不同的信号，主进程根据接收到的信号类型做出不同的处理。比如下面这几个：

- SIGTERM，一种优雅的终止信号，会待进程执行完当前程序之后中断，而不是直接干掉进程
- SIGUSR1，将平稳的重启所有的Worker进程
- SIGUSR2，将平稳的重启所有的Task进程

如果我们要实现重启 server，只需要找到主进程的 PID，然后向主进程发送 SIGUSR1 信号就好了。

> 同理，SIGUSR2 信号是只针对 Task 进程的。

``` shell
echo "reloading..."
pid=`pidof yangzie-test`
echo $pid
kill -USR1 $pid
echo "load success"
```

平滑重启的原理是当主进程收到SIGUSR1信号时，主进程就会向一个子进程发送安全退出的信号，所谓的安全退出的意思是主进程并不会直接把Worker进程杀死，而是等这个子进程处理完手上的工作之后，再让其光荣的“退休”，最后再拉起新的子进程（重新载入新的PHP程序代码）。然后再向其他子进程发送“退休”命令，就这样一个接一个的重启所有的子进程。

我们注意到，平滑重启实际上就是让旧的子进程逐个退出并重新创建新的进程。为了在平滑重启时不影响到用户，这就要求进程中不要保存用户相关的状态信息，即业务进程最好是无状态的，避免由于进程退出导致信息丢失。

在swoole中，重启只能针对Worker进程启动之后载入的文件才有效！什么意思呢，就是说只有在onWorkerStart回调之后加载的文件，重启才有意义。在Worker进程启动之前就已经加载到内存中的文件，如果想让它重新生效，还是只能乖乖的关闭server再重启。

> https://swoole.app/2018/08/10/swoole的平滑重启问题/

## 注意事项 

- 守护进程有优点，必然也存在缺点。我们启用守护进程后，server 内所有的标准输出都会被丢弃，这样的话我们也就无法跟踪进程在运行过程中是否异常之类的错误信息了。
