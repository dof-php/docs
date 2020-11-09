<!-- toc -->

简单来说，DOF 中只有两种方式来使用缓存，自动缓存和手动缓存。两者底层对缓存的操作都是一样，要正常使用也都需要事先配置缓存驱动。

## 自动缓存

自动缓存目前应用在「ORM 存储缓存」上，即可以根据配置自动管理存储缓存。

### 开启 ORM 缓存

默认情况下，ORM 存储类均未使用缓存。根据优先级从高到低，开启 ORM 缓存有以下两种方式：

#### 通过 ORM 类注解 `Cache`

如果某个 ORM 存储类的类注解中包含了 `Cache` 注解，且注解参数为 `1`，即 `@Cache(1)`，则该 ORM 类所有框架自身提供的的数据库操作均会使用缓存管理。

#### 通过环境变量 `ENABLE_ORM_CACHE`

如果某个 ORM 存储类的类注解中不包含了 `Cache` 注解，那么 DOF 还回去按：先到当前 ORM 类所在的领域内环境变量，再到全局的环境变量中查找配置项 `ENABLE_ORM_CACHE` 选项是否打开——即 `ENABLE_ORM_CACHE` 是否为 `true` 或者 `1`。

如果 `ENABLE_ORM_CACHE` 选项打开，那么该 ORM 类所有框架自身提供的的数据库操作也均会使用缓存管理。

### 配置缓存驱动

## 手动缓存

手动缓存指，需要额外的代码来使用缓存。

## `\DOF\DDD\Listenable` 子类

目前只有 `Service` 和 `Listener` 及其子类内部进行可以进行缓存读写操作。代码示例：

```php
$key = 'cache-key';

// 获取基于 key 的专属缓存对象
$cache = $this->cache($key);

// 查看缓存是否存在
$cache->has();

// 获取缓存
$cache->get();

// 设置缓存和有效期
$value = 'cache-value';
$ttl = 60;
$cache->set($value, $ttl);

// 删除缓存
$cache->del();
```

注意：这里的缓存操作需要先获取某个 key 的专属缓存对象才能进行后续的读写操作，后续的读写操作中均不用再指定缓存 key。

> 之所以要先根据 key 获取缓存实例再读写缓存，而不是直接获取缓存实例，再按 key 读写，是为了保证在配置了多台缓存服务器的情况下，能够拿到该 key 实际被存储的缓存连接实例，因为定位缓存服务器的算法也是基于 key 来进行 HASH 计算的。

## `\DOF\DDD\CacheAdaptor`

通过 ddd 模块提供的缓存适配器 `get()` 方法，也可以获取一个缓存实例，不过这种方式过于原始，是上面以及介绍过的缓存使用情况的底层实现，使用不便，一般情况都不会直接这么用。

`CacheAdaptor::get()` 获取缓存实例的方法签名如下：

```
/**
 * Get a cachable instance for a domain origin
 *
 * @param string $origin: One type of domain origin
 * @param string $key: The key of cache data
 * @param string $cfg: Customized cache driver when necessary
 * @param \DOF\Tracer $tracer
 * @param bool $logging: Logging or not where query the driver
 * @return \DOF\Cache\Cachable|null
 */
public static function get(string $origin, string $key, string $cfg = null, Tracer $tracer = null, bool $logging = true) : ?Cachable;
```

## 注意事项

### 默认为文件缓存

若不配置缓存驱动则默认使用文件缓存，可能并不太适合某些场景。

### ORM 缓存管理的地方要求唯一

要在 DOF 框架中正确使用 ORM 缓存，有个非常重要的条件就是 ORM 对应的数据库表的所有操作权限只有当前的 DOF 应用程序自己。

原因很简单，如果实际使用中同一张数据库表有很多项目都可以增删改查，那么其中某一个项目的缓存管理其实是无效的，一定会出现数据不一致带来的问题。
