列表查询接口分页支持。

Port 中应用此 Pipe 表示该接口返回的是一个数据列表，本 Pipe 会自动从请求参数中获取分页参数，并在校验其格式后设置到路由的管道参数中。

## 分页请求参数

- 默认优先级：`__paginate`

比如，获取分页大小为 10 的第 1 页用户数据：

``` http
GET /v1/users?__paginate=size{10},page{1}
```

> 提示：这里的写法也是用到了 IFRSN。

- 备选优先级：`__paginate_size` 和 `__paginate_page`

比如，获取分页大小为 20 的第 2 页用户数据：

``` http
GET /v1/users?__paginate_size=20&__paginate_page=2
```

## 默认参数及自定义

- 最大分页数限制

50。如果需要自定义可以继承本 Pipe 然后重写 `getPaginateMaxSize()` 方法。

``` php
protected function getPaginateMaxSize() : int
{
    return 50;
}
```

- 默认分页大小

10。如果需要自定义可以继承本 Pipe 然后重写 `getPaginateDefaultSize()` 方法。

```php
protected function getPaginateDefaultSize() : int
{
    return 10;
}
```

## Port 中获取分页参数

Port 应用了本 Pipe 后，就可以在 Port Method 中通过路由管道参数获取：

```php
use DOF\Framework\OFB\Pipe\Paginate;

public function list(ListUser $service)
{
    $params = route('params')->pipe->get(Paginate::class);

    return $service->setSize($params->size)->setPage($params->page)->execute();
}
```
