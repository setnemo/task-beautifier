#!/bin/bash

FILE=./deploy.pid
if [ -f "$FILE" ]; then
    date | sed 's/$/: RUN chmod -R 777 storage/'
    chmod -R 777 storage > /dev/null 2>&1 || chmod -R 777 storage >> /var/log/supervisor/laravel-deploy.log
    date | sed 's/$/: RUN updating files owner/'
    chown -R nginx:nginx ./ > /dev/null 2>&1 || chown -R nginx:nginx ./ >> /var/log/supervisor/laravel-deploy.log
    date | sed 's/$/: RUN maintanance mode/'
    php artisan down > /dev/null 2>&1 || php artisan down >> /var/log/supervisor/laravel-deploy.log
    date | sed 's/$/: RUN composer install/'
    composer install > /dev/null 2>&1 || composer install >> /var/log/supervisor/laravel-deploy.log
    date | sed 's/$/: RUN migrations/'
    php artisan migrate --force > /dev/null 2>&1 || php artisan migrate --force >> /var/log/supervisor/laravel-deploy.log
    date | sed 's/$/: RUN npm install/'
    npm i --quiet --no-progress > /dev/null 2>&1 || npm i --quiet --no-progress >> /var/log/supervisor/laravel-deploy.log
    date | sed 's/$/: RUN npm run build/'
    npm run build --silent > /dev/null 2>&1 || npm run build --silent >> /var/log/supervisor/laravel-deploy.log
    date | sed 's/$/: RUN clear caches/'
    php artisan cache:clear
    php artisan config:clear
    php artisan event:clear
    php artisan route:clear
    php artisan view:clear
    date | sed 's/$/: RUN disable maintanance mode/'
    php artisan up > /dev/null 2>&1 || php artisan up >> /var/log/supervisor/laravel-deploy.log
    rm -f ./deploy.pid
else
    date | sed 's/$/: wait for deploy/' && sleep 60
fi
