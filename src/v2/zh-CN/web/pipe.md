<!-- toc -->

## 概念

DOF 中，Web 管道（以下统称 Pipe）代表一个 HTTP 请求，从 DOF Web 内核开始处理，到处理完成返回客户端响应之前，要经过的一种处理过程。

### 分类

以是否真正执行 Port Method 方法为分界线，我们把 Pipe 分为两类：

#### PipeIn

执行 Port Method 方法之前，一个 HTTP 请求要经过的一个过程就叫 PipeIn。`In` 表示请求来的方向。

PipeIn 适合处理对 HTTP 请求的各种校验操作，比如认证授权、请求参数的校验、路由参数的计算等。

#### PipeOut

执行 Port Method 方法之后，一个 HTTP 响应结果要经过的一个过程就叫 PipeOut。`Out` 表示响应返回的方向。

PipeOut 适合处理对 HTTP 响应结果的二次处理，比如重新组装响应结果、包装最终返回的数据格式、请求完成回调执行等。

## 定义 Pipe

### 鸭子模型

定义 Pipe 非常简单而直接，我们不关心 Pipe 类的命名空间，也不管它实际还有其他什么行为，只要这个 Pipe 类里面有我们要的方法，那么就认为它是一个 Pipe。

### 定义一个 PipeIn

只要一个类有一个 `public` 类型的 `pipein()` 方法，那么这个类就是一个 PipeIn。

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

namespace A\B\C\D;

class TestPipeA
{
    public function pipein($request, $response, $route, $port)
    {
    }
}
{%endace%}

`pipein()` 方法接受 4 个参数：

- `$request`：`DOF\Framework\Web\Request` 类的实例，也是当前请求的单实例。
- `$response`：`DOF\Framework\Web\Response` 类的实例，也是当前请求将要返回的响应单实例。
- `$route`：`DOF\Framework\Collection` 类的实例，也是当前请求的路由所有参数的对象单实例表达。
- `$port`：`DOF\Framework\Collection` 类的实例，也是当前请求的路由所对应的 Port 方法所有参数的对象单实例表达。

### 定义一个 PipeOut

只要一个类有一个 `public` 类型的 `pipeout()` 方法，那么这个类就是一个 PipeOut。

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

namespace E\F\G\H;

class TestPipeB
{
    public function pipeout($result, $route, $port, $request, $response)
    {
    }
}
{%endace%}

`pipeout()` 方法接受 5 个参数：

- `$result`: 当前请求执行完成后，Port 返回的结果，可以是任何格式。
- `$route`：`DOF\Framework\Collection` 类的实例，也是当前请求的路由所有参数的单实例对象表达。
- `$port`：`DOF\Framework\Collection` 类的实例，也是当前请求的路由所对应的 Port 方法所有参数的对象单实例表达。
- `$request`：`DOF\Framework\Web\Request` 类的实例，也是当前请求的单实例。
- `$response`：`DOF\Framework\Web\Response` 类的实例，也是当前请求将要返回的响应单实例。

## 使用 Pipe

### Port 内 Pipe 设置

Pipe 使用很简单，在 Port 的路由注解中通过 `PipeIn`，`PipeOut` 两个关键词使用。

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

namespace Domain\User\Http\Port\V1;

/**
 * @PipeIn(A\B\C\D\TestPipeA)
 */
class User
{
    /**
     * @Route(users/{id})
     * @Verb(get)
     * @PipeOut(E\F\G\H\TestPipeB)
     */
    public function show(int $id)
    {
    }
}
{%endace%}


### 全局 Pipe 设置

除了对每个 Port 应用 Pipe 之外，我们还可以在全局的配置文件中设置 Pipe。

#### 跨领域全局设置

可以在 `/config/domain.php` 中配置如下来进行跨领域的全局设置：

``` php
return [
    'http.port.pipein' => [
        \DOF\Framework\OFB\Pipe\GraphQLAlike::class,
    ],

    'http.port.pipeout' => [
        \DOF\Framework\OFB\Pipe\GraphQLAlike::class,
    ],
];
```

#### 领域内全局设置

可以在 `/domain/领域名/__domain__/domain.php` 中配置如下来进行领域内的全局设置：

``` php
return [
    'http.port.pipein' => [
    ],

    'http.port.pipeout' => [
        \DOF\Framework\OFB\Pipe\ResponseSupport::class,
    ],
];
```

### 禁用 Pipe

有时候我们全局设置过了一些 Pipe，但是想在某些个特别的 Port 上不使用某个 Pipe，这时候可以通过 `NoPipeIn` 和 `NoPipeOut` 注解来取消。

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

namespace Domain\User\Http\Port\V1;

class User
{
    /**
     * @Route(users/{id})
     * @Verb(delete)
     * @NoPipeIn(A\B\C\D\TestPipeA)
     * @NoPipeOut(E\F\G\H\TestPipeB)
     */
    public function delete(int $id)
    {
    }
}
{%endace%}
