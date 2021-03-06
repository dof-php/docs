<!-- toc -->

## 面向领域

和典型的 MVC 架构风格的框架不同的是，DOF 提倡使用领域概念来划分业务边界，每个领域都可以是一个子系统，每个子系统都可以有独立的配置和应用结构，因此非常适合采用领域驱动设计思想和微服务的风格来开发一个大型的 Web 应用。

传统单体应用在向微服务化进行转型的过渡期，首先要遇到的问题就是如何划分业务的边界，这个边界如果一开始没有划分好，系统后期再进行调整会非常麻烦。

DOF 可以在同一编程语言的同一项目中共存多个领域的特点，可以让这个过渡期间可以大胆试错，因为调整的代价相比已经分布式部署，甚至采用异构技术结构的微服务子系统而言可以忽略不计。

DOF 提倡先在同一个项目中沉淀出稳定的业务边界，然后再把稳定的领域抽出去单独开发和部署，成为真正的微服务。

## 不仅仅关心编码

DOF 关注一个 Web 应用程序整个生命周期内所要经历的事情，除了提倡编写优雅的代码之外，DOF 在各种自动化支持、文档管理、测试流程、部署与监控等各个方面都在框架层面积极支持。

## 持续集成友好

DOF 尽可能为应用程序的每一个可编程点都提供外部接口，这使编写测试脚本、文档管理、配置注入、数据库版本控制等操作都可以很方便的自动化起来，非常适合与各种持续集成工具配合，做到全自动发布。

## 聚焦业务

除了尽可能把所有纯技术的基础性工作做完，DOF 内置一批通用问题的解决方案，业务可以根据需要开箱即用或者通过注解声明即用，这让业务开发真正只需要关注业务功能本身，尽可能避免枯燥繁琐的底层开发工作而拖累功能开发进度，从而快速交付功能。

## 优雅

DOF 大量采用了注解和语义化概念，可以以声明式的方式承载更多业务逻辑细节，这可以减少大量雷同业务代码的编写。

此外，在设计过程中 DOF 就考虑到了代码结构的问题，什么代码应该写到什么层都有十分严谨的强制规范。

## Swoole 

DOF 可以在 Swoole 中运行，借助其常驻内存、异步 IO、协程等特性实现高性能。

此外，Swoole 各种协议的 Server，为 DOF 多端口提供服务的设计思路提供了底层支持，可以同时为多种协议客户端提供服务。
