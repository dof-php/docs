Dof use git client hook `pre-commit` to increase version raw counts, and use `get_dof_version()` to calculate the version string automatically. 

> I am too lazy to ponder how to version my project.

First we create a shell script:

```
chmod +x .git/hooks/pre-commit > .git/hooks/pre-commit
```

Then contented with:

``` shell
#!/bin/sh

ver="`pwd`/.ver"
cnt="`git rev-list --all --count`"
# Plus 1 here because git client hook `pre-commit` always lag 1 time
let cnt++
echo $cnt > $ver
git add -A
echo "\nUpdated Dof version raw counts to $cnt\n"
```

Done!

After that everytime before we commit, version raw counts will increase 1.
