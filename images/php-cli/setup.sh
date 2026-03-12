#!/bin/sh
set -e

# Change to the application directory (adjust as needed)
# cd /var/www/ledger-reconciliation

composer install --prefer-dist --no-progress --no-interaction --no-dev
php artisan key:generate

# Execute the main command from CMD
exec "$@"
