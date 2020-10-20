<!-- toc -->

本文档是 [DOF PHP](https://github.com/dof-php) 框架 v1.x 的使用开发手册。

## I18N 


<script type="text/javascript">
function switchPath(path) {
	var url = new URL(window.location.href);
	window.location.href = url.origin + '/' + path;
}
</script>

<button>简体中文 (当前)</button>
<button onclick='switchPath("docs/v1/en")' style="color:blue;">English</button>


## 本地预览 

本手册使用 GitBook 编写，若要在本地预览，有两种方式：

### 通过 `gitbook serve`

- 安装 GitBook：

``` shell
npm install gitbook -g
```

- 选择要预览的语言目录，比如 `zh-CN`，运行 GitBook web 服务：

``` shell
git clone https://github.com/dof-php/docs
cd docs/src/v1/zh-CN
gitbook install
gitbook serve
```

### 通过 Web 服务器

``` shell
git clone https://github.com/dof-php/docs
cd docs/docs/v1/zh-CN
python -m SimpleHTTPServer 4000
```

最后，打开浏览器进行浏览：`http://本地域名或本地IP:4000`。

## FAQ

- 左侧章节无法折叠？

检查 `SUMMARY.md` 里面每个分类项的对应的文档是否定义了但是不存在。
