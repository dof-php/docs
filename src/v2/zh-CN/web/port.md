<!-- toc -->

## 概念

DOF 中，Web 端口（以下统称 Port）代表服务端暴露给终端的 HTTP 接口，一个 Port 本质就是一个 RESTful API。

> DOF 项目中默认使用 REST 风格来定义 HTTP 接口。

## 定义 Port

Port 实际是存放于某个领域的 `Http/Port` 目录下的类文件。比如 `Domain\User\Http\Port\V1\User.php`：

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

declare(strict_types=1);

namespace Domain\User\Http\Port\V1;

/**
 * @Route(v1/users)
 * @Suffix(json)
 * @Suffix(xml)
 * @MimeOut(json)
 */
class User
{
    /**
     * @Route({id})
     * @Verb(get)
     */
    public function show(int $id)
    {
        return \compact('id');
    }
}
{%endace%}

至此就定义了一个简单的 Port，且满足以下规则：

- 对应的 REST API 为：`GET /v1/users/{id}`。
- 处理该请求的类为 Port Class 为 `Domain\Users\Http\Port\V1\User::class`，Port Method 为 `show()`。
- Port Class 无需继承其他类，无需实现其他接口，无需引入其他 trait。

- Port Method 修饰符必须为 `public`。
> HTTP 接口生来就是给人调用的，因此 public 最符合其语义。

- 允许 URL 使用后缀：`json` 和 `xml` 均可。
- 响应的 Mime 类型为：`json`（即等同于设置了响应头 `content-type: application/json`)。

## 访问端口

访问刚刚定义的 Port 也很简单，由于是 GET 请求，直接在浏览器打开 `http://app1.dof.dev/v1/users/123456`，会如期返回如下 JSON：

> 根据这里的 Port 定义，和访问 `http://app1.dof.dev/v1/users/123456.json` 结果一样。

``` json
{
    "id": 123456
}
```

或者访问 `http://app1.dof.dev/v1/users/123456.xml`，则会返回如下 XML：

``` xml
<?xml version="1.0" encoding="utf-8"?>
<xml>
    <id>123456</id>
</xml>
```

## 注解

在上面的例子中，可以看到我们在类的注释和类方法的注释中使用了类似 `@Route()` 这样的注解，在 DOF 中会看到大量这样的写法。

Port 中可以使用的注解非常多，关于注解的介绍和用法后面会有专门章节介绍。

> 说明：注解关键字本身不区分大小写。

## 定义自治的 Port 类

所谓的自治的 Port 类指的是一个 Port 只完成一件事情，Port Method 固定为 `execute`，通常也只声明了一个 HTTP API 的 Port。

一些逻辑比较复杂或者拥有很多参数的 HTTP API 的时候，比较适合定义一个自治的 Port，这样可以保持 Port 类的专注和简洁，而不会和其他 Port 定义混合在一起。

定义自治的 Port 也是通过注解的方式——通过在 Port 类的类注解中声明 `Autonomy` 即可：

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

/**
 * @Autonomy(1)
 * @Route(v1/do-sth-complex)
 * @Verb(post)
 */
class DoSthComplex
{
    public function execute()
    {
        // Do sth complex
    }
}
{%endace%}

## Port Method 依赖注入

所有 Port Method 均实现了依赖注入，因此可以在 Port Method 定义中声明一个类类型变量，然后在方法内通过该变量使用类实例。

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

namespace Domain\User\Http\Port\V1;

use Domain\User\Service\Application\ShowUserService;

/**
 * @Route(v1/users)
 * @MimeOut(json)
 */
class User
{
    /**
     * @Route({id})
     * @Verb(get)
     */
    public function show(int $id, ShowUserService $service)
    {
        return $service->setId($id)->execute();
    }
}
{%endace%}

自治 Port 的 `execute()` 方法同理。

## 定义 Port 参数

实际 Web 开发中，绝大部分 HTTP 接口都是带参数和参数校验的，DOF 使这种事情变得简单而优雅。

### Port 类属性作为参数

前面我们定义 Port 类的时候，没有定义过类属性，但实际上 Port 的类属性本身连同其注解同时也是 Port 参数的定义。

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

namespace Domain\User\Http\Port\V1;

use Domain\User\Service\Application\UpdateUserService;

/**
 * @Author(cjli@dofphp)
 * @Version(v1)
 * @Route(users)
 * @MimeOut(json)
 */
class User
{
    /**
     * @Title(User Mobile)
     * @Compatible(phone,tel)
     * @Mobile(cn)
     */
    private $mobile;

    /**
     * @Title(Client Ip)
     * @Ip()
     */
    private $ip;

    /**
     * @Title(User Id)
     * @Compatible(user_id,uid,userId)
     * @Uint(){%s custom error message %s}
     */
    private $id;

    /**
     * @Title(更新用户信息)
     * @Route({id})
     * @Verb(PUT)
     * @Argument(id){need:0&location=URL Path}
     * @Argument(mobile)
     * @Argument(ip){need:0}
     */
    public function update(int $id, UpdateUserService $service)
    {
        \extract($this->route()->arguments);

        return $service
            ->setId($id)
            ->setMobile($mobile)
            // ->setMobile(port('argument')->get('mobile'))
            ->setIp(port('argument')->ip)
            // ->setIp($ip ?? '')
            ->execute();
    }
}
{%endace%}


在这个例子中，声明的东西有：

- REST API：`PUT /v1/users/{id}`
- 该 HTTP API 参数有：
    - `id`: 必须；参数位置是 URL Path（即路由参数）；格式为正整数，有自定义错误提示语；兼容的参数名可以是 `uid`, `userId`, `user_id`。
    - `mobile`：必须；格式为中国大陆手机号；兼容的参数名可以是 `phone`, `tel`。 
    - `ip`：可选；格式为合法的 IP 地址。

通过这些声明，在请求该 HTTP 接口的时候，就会按顺序检查请求参数，并在检查失败的返回错误提示。

> 所有路由参数均是必须的。

### 独立的 Wrapin 类属性作为参数

当要使用独立的 Wrapin 类作为 Port 参数的入参检查时，表示这个 Port 相对比较复杂了，如果不复杂则没必要定义单独的 Wrapin。

声明一个 Port 使用哪个 `Wrapin` 检查请求参数依然是通过注解的形式：

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

namespace Domain\User\Http\Port\V1;

use Domain\User\Service\Application\ListUserService;

/**
 * @Route(v1/users)
 * @MimeOut(json)
 */
class User
{
    /**
     * @Route(/)
     * @Verb(get)
     * @WrapIn(Domain\User\Http\Wrapper\In\User)
     * @Alias(get_user_list)
     */
    public function list(ListUserService $service)
    {
        return paginator($service->execute());
    }
}
{%endace%}

其中 `Domain\User\Http\Wrapper\In\User` 只是定义了一堆属性和注解的类。

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

declare(strict_types=1);

namespace Domain\User\Http\Wrapper\In;

/**
 * This is a demo wrapin
 * Annotation order affect validate result
 */
class User
{
    /**
     * @Title(User Id)
     * @Compatible(id,uid,userId,user_id)
     * @Need()
     * @Ciin(112,333)
     * @Uint()
     */
    private $id;

    /**
     * @Title(客户端 IP 地址)
     * @Compatible(client_ip,ip)
     * @Need()
     * @Default(0.0.0.0)
     * @String()
     * @Ip()
     */
    private $ip;

    /**
     * @Title(用户真实姓名)
     * @Compatible(realname,uname)
     * @NeedIfNo(email)
     * @String()
     * @Min(2)
     */
    private $name;

    /**
     * @Title(用户电子邮箱)
     * @Compatible(mail_addr)
     * @NeedIfNo(name)
     * @Email()
     */
    private $email;

    /**
     * @Title(附加数据)
     * @Array()
     * @Wrapin(ABC){list=1}
     */
    private $extra;
}
{%endace%}

> Wrapin 类使用的注解和 Port 类属性完全一样，只是由于隔离复杂性而被单独出去。

#### Wrapin 和 Argument 的优先级 

注解 `Wrapin` 的优先级比 `Argument` 的高，因此如果一个 Port Method 即声明了 `Wrapin`，又声明了 `Argument`，则 `Argument` 注解会被忽略。

忽略的原因，正如前面所说，Wrapin 应该被用于复杂的情况，当这个 Port 本身参数已经比较复杂的时候，从应该独立地在一个地方解决，而不既在 Port 类属性中找，又到 Wrapin 类属性中去找，这样容易混淆。

#### Wrapin 可以无限嵌套

在上面那个例子中可以看到，Wrapin `Domain\User\Http\Wrapper\In\User` 的 `extra` 属性注解中又使用了 `Wrapin` 注解关联了一个名为 `ABC` 的 Wrapin，表示 `extra` 参数的值还要接受 `ABC` Wrapin 的检查。

> `@Wrapin(ABC){list=1}` 中的 `list=1` 表示 `extra` 属性值是一个列表数组，会循环该列表的每一个子数组进行 ABC wrapin 检查。

### 自治的 Port 类本身相当于 Wrapin

原因也相同，一个 Port 需要自治的时候，表示该 Port 参数比较复杂。自治 Port 只有一个 Method，因此把属性全部定义到其本身是合理的，不会带来混淆，也表明了自治的目的。

自治 Port 的 `execute()` 方法无需在声明 `Argument`，会自动检查该 Port 定义的所有属性。

## 使用 Port 参数

前面的例子中，可以看到三种在 Port Method 中获取 Port 参数的方式：

- 路由参数

比如定义了路由参数 `@Route({id})`，则在 Port Method 中通过方法参数注入进来：

```php
public function update(int $id)
{
    // ...
}
```

- `pargvs()`

该函数返回执行该函数的 Port Method 所定义过的所有参数，以关联数组的形式返回。

配合 `\extract()`，就可以将关联数组中的 KEY 名导入到当前方法内的变量符号表，可以直接通过 KEY 名变量使用。

``` php
\extract($this->route()->arguments);
 
var_dump($param1);
```

- `port('argument')`

`port()` 函数返回执行当前 Port Method 的端口相关所有信息，以 DOF 集合 `DOF\Framework\Collection` 的类型返回。

因此也可以拿到当前端口的参数，此时下面几种写法是等价的：

``` php
port()->argument->get('param1');
port('argument')->get('param1');
port('argument')->param1;
```
