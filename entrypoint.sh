#!/bin/bash

set -e

nohup ./app --allow-all-origins=true  --mermaid=/usr/local/bin/mmdc  --in=./in  --out=./out  --puppeteer=./puppeteer-config.json  2>&1 &

# start ssh server
service ssh start && /bin/bash