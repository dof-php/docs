#!/bin/bash

cd src/v1/en && gitbook install
cd ../../..
gitbook build src/v1/en docs/v1/en

cd src/v1/zh-CN && gitbook install
cd ../../..
gitbook build src/v1/zh-CN docs/v1/zh-CN
