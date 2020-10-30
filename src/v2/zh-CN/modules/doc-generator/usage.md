<!-- toc -->

## 一次性生成所有文档

自动生成所有文档：

``` shell
php dof docs.build.all
# 或者简写：
# php dof docs.build
```

该命令执行结果会根据使用的文档 UI 的不同而不同。

### GitBook

如果是使用 GitBook UI，该命令执行后会在指定的路径（默认项目跟路径下的 `var/` 目录）下生成 `docs-all` 的目录，则生成的目录结构将类似：

```
var/docs-all/
├── build.sh
├── index.html
├── _model
│   ├── book.json
│   ├── README.md
│   ├── SUMMARY.md
│   └── User.Entity.User.md
├── v0
│   ├── book.json
│   ├── README.md
│   ├── SUMMARY.md
│   └── user
│       └── dfe7f2cd36fd6ec30505c7612b254e3e.md
├── v1
│   ├── book.json
│   ├── README.md
│   ├── SUMMARY.md
│   └── user
│       └── user-basic
│           ├── 1d9cad70fccdffe948f0df2c37287add.md
│           ├── 2a8269f6035aef46036bfd4ea40749dc.md
│           ├── 52521ecdd97604815e98fdc3bd1f357f.md
│           ├── c30ca692f81d0a415bc9d126122321b4.md
│           └── df99072ca4d03a00e3038d5d6c3519ba.md
├── v2
│   ├── book.json
│   ├── README.md
│   ├── SUMMARY.md
│   └── user
│       └── online-api
│           └── debug
│               ├── default
│               │   └── ff479790521dda866a3ca2c58f81a236.md
│               └── orm-map
│                   └── b2d3fefb76e7cea6f96da3d6fef59695.md
└── _wrapin
    ├── book.json
    ├── README.md
    ├── SUMMARY.md
    ├── User.Http.Wrapper.In.ABC.md
    └── User.Http.Wrapper.In.User.md
```

然后我们执行里面的 `build.sh` 来生成最终的带有版本选择的静态网站：

``` shell
cd var/docs-all
sh ./build.sh
```

等待 GitBook 插件安装和网站生成完成后，`docs-all` 目录下会生成 `__site` 目录，该目录就是我们最终需要的完整文档静态站点，然后我们就可以将其部署到我们的文档网站。

## 生成 HTTP 接口文档

自动生成 HTTP 接口文档：

``` shell
php dof docs.build.http
```

该命令执行后会在指定的路径（默认项目跟路径下的 `tmp/` 目录）下生成 `docs-http` 的目录，目录结构和前面类似。

在前面的目录结构中，`v0`, `v1`, `v2`（等）就代表 HTTP 接口文档版本。

## 生成数据模型文档

自动生成接口返回值可以使用的数据模型定义文档：

``` shell
php dof docs.build.model
```

该命令执行后会在指定的路径（默认项目跟路径下的 `tmp/` 目录）下生成 `docs-model` 的目录，目录结构和前面类似。

在前面的目录结构中，`_model` 就代表数据模型文档。

## 生成请求参数校验规则文档

自动生成接口请求参数可以使用的校验规则文档：

``` shell
php dof docs.build.wrapin
```

该命令执行后会在指定的路径（默认项目跟路径下的 `var/` 目录）下生成 `docs-wrapin` 的目录，目录结构和前面类似。

前面的目录结构中，`_wrapin` 就代表请求参数校验规则文档。

## 命令选项

- `--save`：指定保存生成文档站点的路径；默认项目路径下的 `var/` 目录。
- `--absolute`：指定保存生成文档站点的路径是否是绝对路径；默认 `0`。
- `--ui`：执行渲染文档的 UI；默认 `gitbook`。

## 文档 UI

目前只支持 GitBook。

### 构建 GitBook 文档静态站点

举例说明，我们生成完接口相关的所有文档后想要构建一份静态的文档站点，可以执行如下命令：

``` shell
php dof docs.build.all && sh var/docs-all/build.sh
```

执行完成后，会在 `var/docs-all/` 目录下生成一个 `__site` 目录，该目录就是完整的可以直接部署的静态网站，可以配合一些持续集成工具将其自动更新到我们的文档站点。
