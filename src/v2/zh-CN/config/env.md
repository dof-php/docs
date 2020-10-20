<!-- toc -->

本文介绍 DOF 中如何配置环境变量。

## 共识

#### 配置键公约

所有环境变量 KEY 一律使用大写+下划线，即常量风格。比如 `A_B_C`。

### 环境变量覆盖 

某些领域环境变量可以覆盖全局环境变量，详见后面的说明。

### 版本控制

不管是全局环境变量还是领域环境变量，实践中都应该被版本控制忽略。DOF 默认也已将其添加到 gitignore。

## 全局环境变量

配置文件位于 `config/env.{suffix}`。

### DOF 预设环境变量

| KEY | 说明 | 基本类型 | 默认值 | 备注 |
| :--- | :--- | :--- | :--- | :--- |
| `CACHE_DRIVER` | 跨领域的缓存驱动配置 | String | `null` | 可以被领域环境变量覆盖 |
| `DOF_SECRET` | DOF 应用使用的密钥 | String | `null` | 可以被领域环境变量覆盖 |
| `DISABLE_QUEUE_FORMATTING` | 是否禁用队列名格式化 | Boolean | `false` | 禁用后所有队列任务入队的队列名均 `default`；可以被领域环境变量覆盖 |
| `ENABLE_ORM_CACHE` | 是否启用 ORM 内置存储缓存 | Boolean | `false` | 可以被领域环境变量覆盖 |
| `EVENT_QUEUE_DRIVER` | 领域事件队列驱动配置 | String | `null` | 可以被领域环境变量覆盖；如果没配置该参数，则领域事件异步化时会去查找 `QUEUE_DRIVER` 的配置 |
| `FILE_LOGGING_SINGLE` | 日志文件写入时是否写到单个文件 | Boolean | `false` | 默认生产环境就是关闭，即会按写日志时的 PHP 进程分日志文件 |
| `HTTP_DEBUG` | 是否启用 HTTP 调试模式 | Boolean | `false` | 启用后如果出现报错/异常，则会直接将上下文信息输出到客户端；日志记录不受此影响 |
| `HTTP_DEBUG_HEADER` | 请求打开调试日志记录的请求头 | String | `DOF_HTTP_DEBUG` | - |
| `HTTP_DEBUG_LOGGING` | 可以使用 HTTP 调试日志记录模式的 KEY 及状态列表 | Array | `[]` | 当请求头中包含了请求打开调试日志记录的请求头，则会判断该请求头的值是否配置在该配置中（且状态正常），有则将本次的请求日志记录到预设的地方 |
| `HTTP_REQUEST_LOG_HEADERS` | HTTP 请求日志中需要记录哪些请求头字段 | Array | `[]` | 数组中每一项请求头 KEY 不区分大小写 |
| `HTTP_REQUEST_LOG_CLIENT` | HTTP 请求日志中是否需要记录客户端参数 | Boolean | `false` | 主要会记录客户端名称、操作系统、IP、端口 |
| `HTTP_REQUEST_LOG_PARAMS` | HTTP 请求日志中是否需要记录本次请求参数 | Boolean | `false` | 接口请求时带的业务参数 |
| `HTTP_REQUEST_LOG_SERVER` | HTTP 请求日志中是否需要记录服务端参数 | Boolean | `false` | 主要会记录服务器用户、主机名、服务器地址、端口、进程号、服务器软件、CGI版本 |
| `LISTENER_QUEUE_DRIVER` | 领域事件监听者队列驱动配置 | String | `null` | 可以被领域环境变量覆盖；如果没配置该参数，则领域事件监听者异步化时会去查找 `QUEUE_DRIVER` 的配置 |
| `ORM_STORAGE_CACHE` | 跨领域的存储缓存驱动配置 | String | `null` | 可以被领域环境变量覆盖 |
| `PORT_DOCS_COMPILE` | 是否启用运行时 Port 文档编译 | Boolean | `false` | 不管是 Web 还是 CLI，都会受此控制 |
| `QUEUE_DRIVER` | 默认队列驱动配置 | String | `null` | 可以被领域环境变量覆盖 |
| `TIMEZONE` | 当前项目使用的时区标志符，必须是 PHP 官方文档中列出的支持的时区 | String | 操作系统默认时区 | 不管是 Web 还是 CLI，都会受此控制 |
| `SWOOLE_HTTP_SERVER_DAEMONIZE` | Swoole HTTP Server 是否以后台守护进程启动 | Boolean | `false` | - |
| `SWOOLE_HTTP_SERVER_LOG` | Swoole HTTP Server 输出的日志文件 | String | - | 建议 `SWOOLE_HTTP_SERVER_DAEMONIZE` 为 `true` 时配置该选项, 可以是项目根路径下的相对路径 也可以是任意可写的绝对路径 |

## 领域环境变量

配置文件位于领域内的 `__domain__/env.{suffix}`。
