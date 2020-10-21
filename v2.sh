#!/bin/bash

cd src/v2/zh-CN && gitbook install
cd ../../..
gitbook build src/v2/zh-CN docs/v2/zh-CN
