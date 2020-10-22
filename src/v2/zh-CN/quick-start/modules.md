<!-- toc -->

本着“自顶向下，分而治之”的思想，2.x 将之前版本中集中的框架代码按功能边界划分成多个子模块，框架前端模块可以根据需要，在顶层的框架核心模块的全局控制下，自由组合所需的功能模块。

DOF 2.x 项目中所有的功能模块如下：

## testing

基于 GWT 描述模型的通用测试框架。可以测试包括 DOF 在内的所有 PHP 项目。

> 建议只在开发环境安装 (`require-dev`，`composer install --no-dev`）。

## utils

封装了一些使用便利、纯粹无状态、无副作用的 PHP 工具类。可以脱离 DOF PHP 框架独立使用。

## logging

DOF PHP 默认日志组件。

## framework

框架核心。定义了 DOF PHP 框架独有的一些基础类、规范和公约。

包括：框架公约、抽象内核、DI 容器、配置管理、对象跟踪器、Err 管理、多语言、领域管理等实现。

## cli

DOF PHP 命令行。为您带来便捷、灵活的命令行使用开发体验。

## ddd

领域驱动设计理论在 DOF PHP 中的实现。

## http

HTTP 服务端开发。既可以运行在典型的 PHP-FPM 进程模式下，也可以运行在 Swoole HTTP Server 模式下。

## storage

DOF 数据存储层。提供了 MySQL/Redis/Memcached 等经典存储驱动的基本数据操作。

## queue

DOF PHP 默认队列实现。简单、实用。

## cache

DOF PHP 默认缓存组件。

## doc-generator

DOF 项目文档生成器。

> 建议只在开发环境安装 (`require-dev`，`composer install --no-dev`）。

## ofb-auth

开箱即用的认证授权解决方案。

## dof

DOF PHP 框架的前端。通过 `composer create-project dof-php/dof` 命令创建的就是该模块。

## docs

> 不是代码模块。

DOF PHP 开发使用文档。即你目前正在浏览的文档。
