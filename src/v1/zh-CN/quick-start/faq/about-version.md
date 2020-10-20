## 0.1.7.14 之后的版本

开始遵守[语义化版本规范](https://semver.org/lang/zh-CN/)，不再根据 Git 提交次数计算版本字符串。

## 0.1.7.14 以及之前的版本

由于本人太懒去想如何给 Dof 定义版本，因此使用了 git 的客户端钩子 `pre-commit` 来自动增加 Dof 的原始版本计数，然后使用函数 `get_dof_version()` 来计算当前的 Dof 版本字符串。 

首先先创建 `pre-commit` 钩子脚本文件：

``` shell
chmod +x .git/hooks/pre-commit > .git/hooks/pre-commit
```

脚本内容如下：

``` shell
#!/bin/sh

ver="`pwd`/.VER.DOF"
cnt="`git rev-list --all --count`"
# Plus 1 here because git client hook `pre-commit` always lag 1 time
let cnt++
echo $cnt > $ver
git add -A
echo "\nUpdated Dof version raw counts to $cnt\n"
```

至此，以后每次 Dof 提交成功一次，其版本号都会递增 1。

然后可以使用命令查看当前使用的 Dof 版本：

``` shell
# 查看 Dof 版本字符串
php dof version

# 查看 Dof 版本原始计数
php dof version --raw
```
