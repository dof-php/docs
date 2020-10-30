此函数与PHP5.5提供的 `cli_set_process_title` 功能是相同的。但 `swoole_set_process_name` 可用于PHP5.2之上的任意版本。`swoole_set_process_name` 兼容性比 `cli_set_process_title` 要差，如果存在 `cli_set_process_title` 函数则优先使用 `cli_set_process_title`。

在 `swoole_server_create` 之前修改为 `manager` 进程名称
onStart 调用时修改为主进程名称
onWorkerStart 修改为worker进程名称
onManagerStart 事件回调设置管理进程的名称

低版本Linux内核和Mac OSX不支持进程重命名

> https://wiki.swoole.com/wiki/page/125.html
