#!/bin/bash

cd src/v1/en && gitbook install
cd ../../..
gitbook build src/v1/en docs/v1/en

cd src/v1/zh-CN && gitbook install
cd ../../..
gitbook build src/v1/zh-CN docs/v1/zh-CN

cd src/v2/zh-CN && gitbook install
cd ../../..
gitbook build src/v2/zh-CN docs/v2/zh-CN

rm -rf .git 2>&1 > /dev/null
git init
git remote add origin git@github.com:dof-php/docs.git
git config user.name dof-php
git config user.email me@dof.php
git add -A
git commit -m 'Sync to GitHub'
git push -f origin master
