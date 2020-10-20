<!-- toc -->

关于数据组装器的概念在「核心概念-数据组装器」有详细介绍，本文举例说明如何在开发 Web 接口中使用数据组装器来实现改变返回结果的格式。

## 给 Port 绑定数据模型和组装器

假设我们定义了一个返回员工详情的接口如下：

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

/**
 * @Route(admins/{id})
 * @Verb(GET)
 * @Assembler(Domain\Admin\Assembler\Admin)
 * @Model(Domain\Admin\Entity\Admin)
 * @PipeOut(\DOF\Framework\OFB\Pipe\GraphQLAlike)
 */
public function show(int $id, ShowAdminService $service)
{
    return $service->setId($id)->execute();
}
{%endace%}

ShowAdminService 的主要任务是根据传入的 `$id` 找到对应的员工实体并返回。

通过上面的 Port 定义，我们能够确定的事情有：

- 该 Port 返回的数据是一个 Admin 实体。

> 通过注解 `@Model` 将该 Port 返回的数据与数据模型 `Domain\Admin\Entity\Admin` 绑定起来了。

- 该 Port 返回的 Admin 实体会经过组装器 `Domain\Admin\Assembler\Admin` 的组装，最终 HTTP 响应的数据格式和 Admin 实体的数据在格式上可能不完全一样。

> 通过注解 `@Assembler` 将该 Port 返回的数据模型与组装器 `Domain\Admin\Assembler\Admin` 绑定起来了。

- 该 Port 使用了 GraphQLAlike 管道。Port Method 的返回数据将受到组装器控制。

> 通过注解 `@PipeOut` 关联。

## GraphQL-Alike PipeOut

注意这里给 Port 应用 GraphQL-Alike 管道是必须的，否则 HTTP Port 无法使用数据组装器。

## 定义实体

Admin 实体定义如下：

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

namespace Domain\Admin\Entity;

use DOF\Framework\DDD\Entity;
use Domain\Admin\Repository\AdminRepository;

class Admin extends Entity
{
    /**
     * @Title(用户创建时间)
     * @Type(Pint)
     * @Notes(格式为时间戳)
     */
    protected $createdAt;

    // ...

    /**
     * @Title(用户创建者 ID)
     * @Type(Uint)
     */
    protected $createdBy;

    /**
     * @Title(用户创建者信息)
     * @Type(Entity)
     */
    protected $creator;

    public function getCreator(AdminRepository $repository)
    {
        return $repository->find($this->createdBy);
    }
}
{%endace%}

## 定义组装器

Admin 组装器定义如下：

{%ace edit=true, lang='php', check=false, theme="monokai" %}
<?php

namespace Domain\Admin\Assembler;

use DOF\Framework\DDD\Assembler;

class Admin extends Assembler
{
    protected $compatibles = [
        'created_at' => 'createdAt',
    ];

    protected $converters = [
        'createdAt' => 'formatTimestamp',
    ];

    protected $assemblers = [
        'creator' => Admin::class,
    ];

    public function formatTimestamp(int $ts = null, array $params = [])
    {
        $format = $params['format'] ?? '0';
        $empty = '-';
        switch ($format) {
            case '3':
                $format = 'd/m/Y H:i:s';
                break;
            case '2':
                $format = 'y/m/d H:i:s';
                break;
            case '1':
                $format = 'Y-m-d H:i:s';
                break;
            case '0':
            default:
                $empty = '';
                return $ts;
        }

        return $ts ? fdate($ts, $format) : $empty;
    }
}
{%endace%}

## 请求

``` shell
curl -v http://app1.dof.dev/v1/admins/2?__fields=id,createdBy,createdAt{format:1}
```

在不使用组装器之前，上面的接口返回的数据格式大致会是如下格式：

``` json
{
    'id': 2,
    'createdBy': 1,
    'createdAt': 1551225486,
}
```

使用组装器之后，上面的接口返回的数据格式大致会是如下格式：

``` json
{
    'id': 2,
    'createdBy': 1,
    'createdAt': '2019-02-26 23:58:06',
}
```

对比两种结果，不同的原因使用组装器后，通过解析 `__fields` 字段列表和参数，组装器 `formatTimestamp()` 方法被执行了。这就是数据组装器在 HTTP Port 中起到的作用。
