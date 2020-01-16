#!/bin/bash

ROOT_DIR="$(cd "$(dirname $0)" && pwd)"/../../..

ln -fs $ROOT_DIR/project/config/production/nginx/customer_api.conf /etc/nginx/sites-enabled/customer_api
/usr/sbin/service nginx reload

/bin/bash $ROOT_DIR/project/tool/dep_build.sh link
/usr/bin/php $ROOT_DIR/public/cli.php migrate:install
/usr/bin/php $ROOT_DIR/public/cli.php migrate

ln -fs $ROOT_DIR/project/config/production/supervisor/customer_api_queue_worker.conf /etc/supervisor/conf.d/customer_api_queue_worker.conf
/usr/bin/supervisorctl update
/usr/bin/supervisorctl restart customer_api_queue_worker:*

ln -fs $ROOT_DIR/project/config/production/crontab/customer_api /etc/cron.d/customer_api
