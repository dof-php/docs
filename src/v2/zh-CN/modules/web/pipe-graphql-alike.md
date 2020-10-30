GraphQL 大家都知道，但是 DOF 的 GraphQLAlike 是指目标和 GraphQL 类似，但是形式却和 GraphQL 不同的一种另一种更简单的解决方案。

说明：本 Pipe 默认并未启用，因此项目中需要手动配置，推荐配置到全局领域配置 `http.port.pipeout` 中。

## 接口数据模型

DOF 的每个 HTTP 接口都会显式或隐式地关联某个数据模型，每个数据模型都有一系列属性，这些属性是就是可以被客户端按需返回的字段。

## 参数字段名

如果没有特殊说明，均固定为 `__fields`。返回的数据本身就会自动组装成和 `__fields` 指定的参数列表结构。

## IFRSN

GraphQLAlike Pipe 内部使用了 [IFRSN（Input Fields Relation Structured Notation）](https://dof-php.github.io/docs/zh-CN/component/dsl-ifrsn.html) 来描述字段及其结构，但在使用上又简化了一些。

## 实例

假设接口关联了用户实体 (User.Entity.User) 作为其数据模型，用户实体拥有属性如下：

| 属性 | 类型 | 说明 | 可接受参数 |
| :--- | :--- | :--- | :--- |
| name | String | 姓名 | - |
| mobile | String | 手机号 | - |
| creator | Entity | 用户创建人 - User.Entity.User | - |
| createdAt | Uint | 注册时间 | `{"0":{"tpl":"Y-m-d H:i:s","demo":"2018-12-16 19:05:44"},"1":{"tpl":"y/m/d H:i:s","demo":"18/12/16 19:05:44"},"2":{"tmp":"d/m/y H:i:s","demo":"16/12/2018 19:05:44"},"default":"1"}`|

则：

- 获取某个用户的姓名和手机号

``` http
GET /v1/users/1?__fields=name,mobile

{
    "name": "xxxx",
    "mobile": "133xxxx3333"
}
```

- 获取某个用户的手机号码和注册时间，并按自定义格式显式

``` http
GET /v1/users/1?__fields=mobile,createdAt{format:0}

{
    "mobile": "133xxxx3333",
    "createdAt": '2019-01-01 10:10:10'
}
```

可以看到，这里的字段 `createdAt` 还跟了一个字段参数 `{format:0}`，这个字段参数表示将从用户实体的 `createdAt` 属性中的可接受参数中去查找对应的数据格式编号为 `0` 的格式并应用到注册时间的格式显式。

- 获取用户的创建人信息

``` http
GET /v1/users/1?__fields=name,mobile,creator(name)

{
    "name": "xxxx",
    "mobile": "133xxxx3333",
    "creator": {
        "name": "yyyy",
    } 
}
```

## 注意事项

- 当字段的类型为实体列表（ListArrayOfReference）时，且需求为递归查找时，那么作为参数传到请求的该字段一定要包括 `()`，而 `()` 中的字段可以一个都不要。

在类似无限分类的应用场景中，我们可以只通过 `__fields` 语法实现，而无需改造我们 Service 组装逻辑或者 Storage 的查询逻辑。比如：

``` http
GET /v1/categories/1?__fields=children(),id,title

{
    "id": 1,
    "title": "cate-1",
    "children": [
        {
            "id": 2,
            "title": "cate-2",
            "children": [
                {
                    "id": 3,
                    "title": "cate-3",
                    "children": null
                }
            ]
        }
    ] 
}
```
