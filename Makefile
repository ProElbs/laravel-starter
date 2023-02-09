PHP_SERVICE := php
DB_SERVICE := dbstarter
PROJECT_NAME := laravel-starter

##########
# DOCKER #
##########
build:
	@docker-compose build
	@docker-compose up -d
build-prod:
	@docker-compose build
	@docker-compose -f docker-compose.prod.yml up -d
start:
	@docker-compose up -d
start-prod:
	@docker-compose -f docker-compose.prod.yml up -d
stop:
	@docker-compose stop
restart:
	@docker-compose stop
	@docker-compose up -d
bash:
	docker exec -it $(PROJECT_NAME)_$(PHP_SERVICE)_1 bash

############
# COMPOSER #
############
composer-install:
	@docker-compose exec -T $(PHP_SERVICE) composer install
composer-install-prod:
	@docker-compose exec -T $(PHP_SERVICE) composer install --no-dev --optimize-autoloader

############
# DATABASE #
############
install-db:
	@docker-compose exec -T $(PHP_SERVICE) php artisan migrate:fresh

migrate-status:
	@docker-compose exec -T $(PHP_SERVICE) php artisan migrate:status

migrate-rollback:
	@docker-compose exec -T $(PHP_SERVICE) php artisan migrate:rollback

#########
# TOOLS #
#########
phpstan:
	@docker-compose exec -T $(PHP_SERVICE) vendor/bin/phpstan analyse -l 8 app --memory-limit=4G

pint:
	@docker-compose exec -T $(PHP_SERVICE) vendor/bin/pint

pint-test:
	@docker-compose exec -T $(PHP_SERVICE) vendor/bin/pint --test

###########
# ARTISAN #
###########
cache-clear:
	@docker-compose exec -T $(PHP_SERVICE) php artisan route:clear
	@docker-compose exec -T $(PHP_SERVICE) php artisan view:clear
	@docker-compose exec -T $(PHP_SERVICE) php artisan cache:clear
	@docker-compose exec -T $(PHP_SERVICE) php artisan config:clear

#########
# TESTS #
#########
phpunit:
	@docker-compose exec -T $(PHP_SERVICE) vendor/bin/phpunit

###########
# GLOBALS #
###########
install: build composer-install install-db cache-clear

