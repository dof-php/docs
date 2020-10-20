<!-- toc -->

## 概念

Dof 中，Web 包装器 (以下统称 Wrapper) 表示在一个 HTTP 会话的某个方向（请求进来、响应返回）上，要对这个方向所携带的数据进行包装和检查是否符合包装要求的一种机制。

### Port Method 返回的始终是业务数据本身

这里注意 Port Method 返回的数据是业务数据本身，而不带任何格式。

接口最终的返回响应数据 = Port Method 返回的业务数据本身 + 应用到该 Port Method 的包装器格式所组成。

### 包装器分类

Dof 有三种 Wrapper：

#### WrapIn

对 Http 请求参数格式合法性进行校验的 Wrapper 就叫 WrapIn。

#### WrapOut

对成功的 Http 响应数据按格式进行打包的 Wrapper 就叫 WrapOut。

#### WrapErr

对失败的 Http 响应数据按格式进行打包的 Wrapper 就叫 WrapErr。

## 定义 Wrapper

定义 WrapOut 和 WrapErr 和定义 Pipe 一模一样：我们不关心 Wrapper 类的命名空间，也不管它实际还有其他什么行为，只要这个 Wrapper 类里面有我们要的方法，那么就认为它是一个 Wrapper。

但是定义一个 WrapIn 就比较特殊了，因为 WrapIn 不强制任何方法。

### 定义一个 WrapIn

WrapIn 是一个有若干个类属性及其注解的类文件，可以没有任何方法。

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

namespace Domain\User\Http\Wrapper\In;

class ABC
{
    /**
     * @Title(test var)
     * @Mobile(tw)
     * @Need()
     * @Default(13344445558)
     * @In(13344445555,13344445558)
     */
    private $var;

    /**
     * @Title(demo var)
     * @NeedIfHas(var)
     * @Ip()
     */
    private $a;
}
{%endace%}

### 定义一个 WrapOut

只要一个类有一个 `public` 类型的 `wrapout()` 方法，那么这个类就是一个 WrapOut，每个 `wrapout()` 不接受任何参数，且必须返回一个纯数组。

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

namespace A\B\C;

class D
{
    public function wrapout() : array
    {
        return ['__DATA__' => 'data', 'message' => 'ok'];
    }
}
{%endace%}

### 定义一个 WrapErr

只要一个类有一个 `public` 类型的 `wraperr()` 方法，那么这个类就是一个 WrapErr，每个 `wraperr()` 不接受任何参数，且必须返回一个纯数组。

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

namespace E\F\G;

class H
{
    public function wraperr() : array
    {
        return ['code', 'error'];
    }
}
{%endace%}

## 使用 Wrapper

### Port 内 Wrapper 设置

Wrapper 的使用也很简单，在 Port 的路由注解中通过 `WrapIn`，`WrapOut`, `WrapErr` 三个关键词使用。

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

namespace Domain\User\Http\Port\V1;

/**
 * @WrapIn(Domain\User\Http\Wrapper\In\ABC)
 */
class User
{
    /**
     * @Route('users/{id}')
     * @Verb(get)
     * @WrapOut(A\B\C\D)
     * @WrapErr(E\F\H\G)
     */
    public function show(int $id)
    {
    }
}
{%endace%}

### 全局 Wrapper 设置

#### 跨领域全局设置

可以在 `/config/domain.php` 中配置如下来进行跨领域的全局设置：

``` php
return [
    'http.port.wrapin' => [
        A\B\C::class,
    ],
    'http.port.wrapout' => [
        B\C\D::class,
    ],
    'http.port.wraperr' => [
        C\D\E::class,
    ],
];
```

#### 领域内全局设置

可以在 `/domain/领域名/__domain__/domain.php` 中配置如下来进行领域内的全局设置：

``` php
return [
    'http.port.wrapin' => [
        A\B::class,
    ],
    'http.port.wrapout' => [
        B\C::class,
    ],
    'http.port.wraperr' => [
        C\D::class,
    ],
];
```
