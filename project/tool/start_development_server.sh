#!/bin/bash

ROOT_DIR="$(cd "$(dirname $0)" && pwd)"/../..

sh $ROOT_DIR/project/tool/dep_build.sh link

sudo docker run --rm -ti -p 80:80 -p 8080:8080 -p 3306:3306 --name customer_api \
    -v $ROOT_DIR/../frame:/var/www/frame \
    -v $ROOT_DIR/:/var/www/customer_api \
    -v $ROOT_DIR/project/config/development/nginx/customer_api.conf:/etc/nginx/sites-enabled/default \
    -v $ROOT_DIR/project/config/development/supervisor/customer_api_queue_worker.conf:/etc/supervisor/conf.d/customer_api_queue_worker.conf \
    -e 'TIMEZONE=Asia/Shanghai' \
    -e 'AFTER_START_SHELL=/var/www/customer_api/project/tool/development/after_env_start.sh' \
kikiyao/debian_php_dev_env start
