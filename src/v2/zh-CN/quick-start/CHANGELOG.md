<!-- toc -->

## v2.0.0

### 新特性

#### 模块化

按功能边界将框架代码拆分成多个具体的模块，然后项目中根据需要引入所需的功能模块。

#### 对象 Tracker

引入到内核中后可以实现对内核生命周期内对象实例化链的监控。方便排查问题。

#### Exceptor

一种更简单、更灵活的异常处理方式。

#### 三种代码

- system：框架提供的代码。

- domain：框架用户自己在领域目录内编写的业务代码。

- vendor：遵守 DOF PHP 框架规范编写的软件包和其他通用 Composer 类库。

### 优化

#### Swoole 支持

为更好支持常驻内存运行模式（Swoole）而重写了大量类文件。2.x 将之前代码中无状态的静态工具类规划到 `utils` 模块，将有状态的静态类可常驻内存化，其余类文件均不包含静态属性和静态方法。

#### Manager 规范化

进一步统一了 Manager 行为，重写了部分 Manager 中比较复杂的实现过程。

### 弃用

- 取消所有用户自定义函数定义，几乎所有函数功能均重写到 `utils` 模块。