本文介绍如何在 DOF 配置领域本身。

## 全局领域配置

配置文件路径：`config/domain.php`。

可配置项列表：

| KEY | 说明 | 基本类型 | 默认值 | 备注 |
| :--- | :--- | :--- | :--- | :--- |
| `http.preflight` | Web 内核路由之前要执行的预检过程 | Array | `[]` | 数组每项为一个 Preflight 类命名空间 |
| `http.port.pipein` | Web 内核路由之后执行 Port Method 之前要经过的管道 | Array | `[]` | 数组每项为一个 PipeIn 类命名空间 |
| `http.port.pipeout` | Web 内核执行 Port Method 之后，返回响应数据之前要经过的管道 | Array | `[]` | 数组每项为一个 PipeOut 类命名空间 |
| `http.port.wraperr` | Web 错误响应的数据结果使用的包装器 | Array | `[]` | 数组每项为一个 WrapErr 类命名空间 |
| `http.port.wrapout` | Web 成功响应的数据结果使用的包装器 | Array | `[]` | 数组每项为一个 WrapOut 类命名空间 |

## 领域内部配置

配置文件路径：`__domain__/domain.php`。

可配置项列表：

| KEY | 说明 | 基本类型 | 默认值 | 备注 |
| :--- | :--- | :--- | :--- | :--- |
| `title` | 领域标题 | String | `null`| - |
| `http.port.route` | 领域内统一 HTTP 路由前缀 | String | `null`| - |
| `docs.groups` | Port 注解中路由组 ` Group` 中定义 KEY 到的生成文档显示标题转换对照表 | AssocArray | `[]`| - |
| `docs.appendixes` | 领域内文档附录 | Array | `[]`| 用于在自动生成文档的时候插入一些自定义文档到生成的结果中去；每项的配置格式详见「自动化」/「文档」/「附加自定义文档」 |
| `HTTP_REQUEST_PARAMS_MASK_KEYS` | HTTP 请求参数记录到日志时选择要对参数值进行掩码操作的参数 KEY 列表 | IndexArray | `[]`| 数组的每一项为参数的 KEY 名；主要用于日志脱敏 |
| `MAX_PAGINATE_SIZE` | 领域内 HTTP 接口如果返回分页数据的时候能返回的最大分页长度 | Pint | 50 | - |

## 其他

- 框架配置可以被领域配置覆盖。
- 框架配置要被版本控制。
