## 设计目标

- 人生苦短 希望 DOF 用户能够早点下班

- Get shit done quickly and elegantly

- 用一种好方法解决好一件事情

> 每一种功能的实现，框架底层尽量选择并实现最合适的解决办法，**尽量** 不要让框架使用者面临太多选择，因为选择过多令人困惑。

- 尽可能提供更多的开箱即用的功能

- 自力更生 吃自己的狗粮 能不依赖就不依赖

> 与其踩别人的坑，为什么不自己写个“坑”呢。当然专业性过强的领域还是要选择成熟的解决方案，要有敬畏之心。
> 在能满足自己需求的和能力要求的前提下适当造轮子，但是不要勉强自己为了造轮子而造轮子。

- 能用规范约定俗成就不要单独的配置文件

> 配置的灵活与自由有时候是要付出代价的。

- 做标准 做规范 做协议

> 将 DOF 设计成一个标准，本身没有太多的实现，但是可以挂载很多实现了 DOF 风格的模块。

- 从各个方面考虑框架设计

> 后端开发、前端开发、移动开发、架构、运维、大数据、技术管理、产品、运营、测试、效率

## TODO

- PHP 原生操作抽象层

将一些 IO 阻塞、同步的 PHP 默认函数封装到类，以便于在 Swoole 等场景下引入更适合常驻内存运行模式下的类替换对应实现。

- Swoole Redis/MySQL 连接池

> https://zhuanlan.zhihu.com/p/165006672


## DOF 模块开发规范

- 所有第三方软件包之间不能有依赖，在框架启动的时候 hook 的代码不能有先后顺序要求，如果有执行顺序要求，就请放在同一个软件包中。

- 所有第三方软件包的 CLI 命令不能冲突，请使用安全的命令前缀。

- 所有 Manager 均提供一个 `vendor` 方法不限制次数地将第三方软件包的类文件/目录 安装到 DOF framework

- 模块安装/卸载命令：

```shell
# 把一个第三方软件包安装到 dof 项目
php dof vendor.install --all

# 把一个第三方软件包从 dof 项目中移除/卸载
php dof vendor.remove --all
```

## 1.x -> 2.x 函数名/类名替换常用命令

```
# 删除所有日志文件
find var -type f -iname '*.log' -exec rm -rf {} \;

# 删除所有编译文件
find var -type f -iname '*.compile' -exec rm -rf {} \;

# 搜索指定目录下所有文件中包含特定字符串并替换
grep -rIl --exclude-dir="\.git" --exclude=".*" DOFS domain | xargs sed -i 's/DOFS/DOF/g'
find src \( ! -regex '.*/\..*' \) -type f | xargs sed -i 's/DOFS/DOF/g'

# 忽略搜索二进制文件
grep -rIl --exclude-dir="\.git" --exclude=".*" DOFS domain | xargs sed -i 's/DOFS/DOF/g'

# demos
grep -riIl --exclude-dir="\.git" --exclude="*.log" 'notify' .
find . -iname "*.md" -not -path "./node_modules/*" -type f | xargs sed -i 's/Dof/DOF/g'
grep -rIn --exclude-dir="node_modules" Dof .
grep -rIn --exclude-dir="\.git" --exclude=".*" objectname .
grep -rIn --exclude-dir="\.git" --exclude=".*" Reflect:: .
grep -rIl --exclude-dir="\.git" --exclude=".*" 'Dof\\Framework' src | xargs sed -i 's/Dof\\Framework/DOF/g'
grep -rIl --exclude-dir="\.git" --exclude=".*" __CLASS__ . | xargs sed -i 's/__CLASS__/static::class/g'
grep -rIl --exclude-dir="\.git" --exclude=".*" excp . | xargs sed -i 's/excp/err/g'
grep -rIl --exclude-dir="\.git" --exclude=".*" ERR:: . | xargs sed -i 's/ERR::/\\DOF\\ERR::/g'
grep -rIl --exclude-dir="\.git" --exclude=".*" DOFRR:: . | xargs sed -i 's/DOFRR::/\\DOF\\ERR::/g'
grep -rIl --exclude-dir="\.git" --exclude=".*" Kernel::formatCompileFile . | xargs sed -i 's/Kernel::formatCompileFile/self::formatCompileFile/g'
grep -rIl --exclude-dir="\.git" --exclude=".*" '\\DOF\\' . | xargs sed -i 's/\\DOF\\//g'
grep -rIl --exclude-dir="\.git" --exclude=".*" 'GWT::' . | xargs sed -i 's/GWT::/$gwt->/g'
```

## FAQ

- 为什么把所有领域的私有配置文件移动到项目目录的 `/etc` 目录？

为了统一配置型文件的管理（和 ini/i18n 保持一致）而不需要为每种配置写一个读写类，以及，为了方便项目设置 gitignore。

- 为什么框架要单独一个 Convention.php？

也考虑过废弃，或者定义到常量属于的类里面去。但是取舍了下还是坚持保留，理由是：为了统一 DOF 模块的行为，同时方便集中查看框架内部所有约定俗成的东西，只要 Convention 类中定义的常量均为 DOF 公约，无需纠结框架其他类中还有类似自定义常量。

然后可以减少一个类中引入多个其他类常量的命名空间引入数量。

- 为什么 HTTP Response 类 `send()` 方法没有用 exit 还是能返回响应？

代码流程本身执行完了呗。

- 创建了很多 Exception 类文件？

请使用 Exceptor + Err 来处理异常和用户错误。可以极大地减少 Exception 类文件数量。