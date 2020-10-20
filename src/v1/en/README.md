<!-- toc -->

This documentation is the manual of [DOF PHP](https://github.com/dof-php) framework。

## I18N 


<script type="text/javascript">
function switchPath(path) {
	var url = new URL(window.location.href);
	window.location.href = url.origin + '/' + path;
}
</script>

<button onclick='switchPath("docs/v1/zh-CN")' style="color:blue;">简体中文</button>
<button>English (current)</button>


## Preview

This manual is written with GitBook, there are two ways to preview this manual in your computer if you need to: 

### Using `gitbook serve`

-  Install GitBook first

``` shell
npm install gitbook -g
```

- Select one language to preview, like `en`, and start GitBook web service:

``` shell
git clone https://github.com/dof-php/docs
cd docs/src/v1/en
gitbook install
gitbook serve
```

### Using a web server

``` shell
git clone https://github.com/dof-php/docs
cd docs/docs/v1/en
python -m SimpleHTTPServer 4000
```

Finally, open browser and visit: `http://local-domain|local-ip:4000`。
