<!-- toc -->

本文列出了 Web 端口中会使用到的注解关键字。

> 说明：所有路由注解和注解参数实际均不区分大小写。

## A

### `Argument`

声明该 Port Method 所需的请求参数信息，从当前 Port 的属性中查找。

### `Auth`

认证授权声明。只能是以下几个值：

- `0`: 无需认证无需授权。
- `1`: 只需认证无需授权。
- `2`: 只需授权无需认证。
- `3`: 同时需要认证和授权。

### `Author`

接口作者/负责人。自动生成文档时的必备属性之一。

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

declare(strict_types=1);

namespace Domain\Http\Port\V1;

/**
 * @Author(demo@dofphp.org)
 */
class Dof
{
}
{%endace%}

### `Alias`

给当前接口的路由起一个别名。

> 注意别名全局不可重复。

### `Assembler`

给当前接口返回的数据应用一个数据组装器，以改变最终返回的数据。

### `Autonomy`

声明当前的 Port 类是否是自治的端口。

## C

### `CodeOK`

声明对当前接口的请求成功时返回的 HTTP 状态码。

## G

### `Group`

自动生成接口文档时的可选属性之一，用于分组接口文档。

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

declare(strict_types=1);

namespace Domain\Http\Port\V1;

/**
 * @Group(abc/def)
 */
class Dof
{
}
{%endace%}


注意，`Group` 注解值的 KEY 要完全一致的分组才会归档到同一个接口分类下。

> 如果你要给你的分组 KEY 指定一个显示标题，则需要在领域配置文件中配置 `docs.groups` 数组属性即可，数组的 KEY 为 `Group` 的以 `/` 隔开的每一项，比如这里的 `['abc' => '组名1', 'def' => '组名2']`。

> 这样配置后生成文档时显示的接口分组就不是 `abc/def` KEY 名，而是 `组名1/组名2` 了。

## H

### `HeaderStatus`

声明当前 HTTP 接口可能返回的一个状态码，以及对返回该状态码的一些解释。

### `HeaderIn`

声明当前接口需要的一项请求头信息，可重复声明。

### `HeaderOut`

声明当前接口会返回的一项响应头信息，可重复声明。

## I

### `InfoOK`

声明对当前接口的请求成功时返回的文本信息。

## L

### `Logging`

给当前接口声明一个请求日志记录切面接入点，以自动记录对该接口的请求日志。

### `LogMaskKey`

声明一个启用 `Logging` 注解日志记录时候要进行掩码处理的请求参数 KEY，声明后当启用了 Logging 则日志中相应的 KEY 将变为 `*`。可重复声明。

## M

### `MimeIn`

HTTP 请求的 Mime 类型别名。别名及其 `Content-Type` 对应和 `MimeOut` 完全一样。

### `MimeOut`

HTTP 响应的 Mime 类型别名。别名及其 `Content-Type` 对应如下：

``` php 
'text' => 'text/plain',
'html' => 'text/html',
'view' => 'text/html',
'json' => 'application/json',
'xml'  => 'application/xml',
'form' => 'application/x-www-form-urlencoded',
```

### `MaxPageSize`

当前 HTTP 接口返回分页数据时最多能返回的数据条数，即最大分页数。

### `Model`

当前接口关联的数据模型。

## N

### `NoDoc`

声明该接口不要被自动生成文档流程所读取，最终效果是该接口不会出现在自动生成的接口文档中。


### `NotRoute`

声明该 Port Method 并不是一个 HTTP 路由，同时功能上相当于隐式使用了 `NoDoc`。

### `NoPipeIn`

声明当前接口不要使用某个 PipeIn 管道。可重复声明。

### `NoPipeOut`

声明当前接口不要使用某个 PipeOut 管道。可重复声明。

### `NoDump`

声明该 Port Method 是一个 HTTP 路由，但是不会被框架命令 `port.dump`（端口路由导出）所读取。

### `Notes`

接口备注，如果声明了会以段落文本的格式出现在文档底部。`Remark` 注解的别名。

## P

### `PipeIn`

请求入方向管道。执行 Port Method 方法之前，一个 HTTP 请求要经过的一个过程就叫 PipeIn。

### `PipeOut`

响应出方向管道。执行 Port Method 方法之后，一个 HTTP 响应结果要经过的一个过程就叫 PipeOut。

## R

### `Route`

定义路由中 URL path 的组成部分，不一定代表最终的路由定义。

### `Remark`

接口备注，如果声明了会以段落文本的格式出现在文档底部。`Notes` 注解的别名。

## S

#### `SubTitle`

路由附标题。自动生成文档时的可选属性之一。

### `Suffix`

URI 资源后缀。表示当前路由支持通过在 URL 末尾通过该后缀来访问，支持多项配置。

> 说明：该特性在 CDN 缓存接口动态数据时可能会有帮助。


{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

declare(strict_types=1);

namespace Domain\Http\Port\V1;

/**
 * @Suffix(xml)
 * @Suffix(json)
 * @Suffix(aaa,bbb)
 */
class Dof
{
}
{%endace%}

如果路由注解中没有声明资源后缀，但是访问时带上了资源后缀，则会返回找不到路由这样的提示。

如果路由注解中带有资源后缀，而且该资源后缀是 HTTP Content-Type 的别名，则返回响应的数据格式会自动解析成该类型。

其中 Dof 中可以使用的 HTTP Content-Type 别名和前面 `MimeOut` 的别名列表中的 KEY 保持一致。

### `Status`

当前接口的状态，无任何实际性功能作用，只是在接口开发人想要告知阅读接口文档的人当前接口的状态的时候有用。

## T

#### `Title`

路由主标题。自动生成文档时的必备属性之一。

## V

### `Verb`

定义路由的请求方式，支持 HTTP 所有动词。可为同一个 Port 定义多个 Verb。

### `Version`

接口版本声明。主要被用于自动生成文档时作为文档的一级目录。

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

declare(strict_types=1);

namespace Domain\Http\Port\V1;

/**
 * @Version(v1)
 */
class Dof
{
}
{%endace%}

也会作为路由定义的最开始前缀，不过该特性可以通过注解参数禁用：

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

declare(strict_types=1);

namespace Domain\Http\Port\V1;

/**
 * @Version(v1){route=0}
 */
class Dof
{
}
{%endace%}

其中的注解参数 `route` 默认为 1，表示启用版本声明作为路由开始前缀的特性。

## W

### `WrapErr`

当业务逻辑中指明 HTTP 响应包含逻辑错误时，对响应数据要使用的包装格式，注解值只能是一个 WrapIn 类命名空间。

一个 Port Method 只能有一个 WrapErr。

### `WrapIn`

对正常 HTTP 请求数据包要使用的包装格式，注解值只能是一个 WrapIn 类命名空间。

一个 Port Method 只能有一个 WrapIn。

### `WrapOut`

对正常 HTTP 响应数据包要使用的包装格式，注解值只能是一个 WrapIn 类命名空间。

一个 Port Method 只能有一个 WrapOut。
