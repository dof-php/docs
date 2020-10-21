#!/bin/bash

#rm -rf .git 2>&1 > /dev/null
#git init
#git remote add origin git@github.com:dof-php/docs.git
git config user.name dof-php
git config user.email me@dof.php
git add -A
git commit -m 'Sync to GitHub'
git push origin master -f
