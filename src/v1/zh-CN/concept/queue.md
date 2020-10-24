## 使用 Redis 作为队列存储驱动

| 队列名 | 存储类型 | 说明 | 示例 |
| :--- | :--- | :--- | :--- |
| normal | LIST | 正常的队列任务名/等待 worker 执行；可省略 | `__dof_queue:{QUEUE}` |
| failed | ZSET | 失败的队列任务；score 为时间戳 | `__dof_queue_failed:{QUEUE}` |
| timeouted | zset | 超时队列任务；score 为时间戳 | `__dof_queue_timeouted:{QUEUE}` |
| running | zset | 正在执行的队列任务；score 为开始执行时间戳 | `__dof_queue_timeouted:{QUEUE}` |
| fast | list | 高速队列 | `__dof_queue_fast:{QUEUE}` |
| slow | list | 慢速队列 | `__dof_queue_slow:{QUEUE}` |

## 命令行

- 查看当前运行失败的队列任务

输出字段包括：队列名、失败的任务数量、最后失败时间、尝试次数。

``` shell
## --queue 指定想要查看的队列名 以英文逗号隔开 支持相同前缀名往后匹配
php dof queue.failed
```

- 查看当前正常等待执行的队列任务

输出字段包括：队列名、等待的任务数量。

``` shell
## --queue 指定想要查看的队列名 以英文逗号隔开 支持相同前缀名往后匹配
php dof queue.list
```

- 查看当前正在执行的队列任务

输出字段包括：队列名、剩余的任务数量。

``` shell
## --queue 指定想要查看的队列名 以英文逗号隔开 支持相同前缀名往后匹配
php dof queue.running
```
