PHP_SERVICE := php
DB_SERVICE := dbtuto

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

############
# COMPOSER #
############
composer-install:
	@docker-compose exec -T $(PHP_SERVICE) composer install
composer-install-prod:
	@docker-compose exec -T $(PHP_SERVICE) composer install --no-dev --optimize-autoloader

############
# TODO DATABASE #
############
install-db:
	@docker-compose exec -T $(PHP_SERVICE) bin/console doctrine:database:drop --force
	@docker-compose exec -T $(PHP_SERVICE) bin/console doctrine:database:create
	@docker-compose exec -T $(PHP_SERVICE) bin/console doctrine:migrations:migrate

migrations-diff:
	@docker-compose exec -T $(PHP_SERVICE) bin/console doctrine:migrations:diff

migrations-migrate:
	@docker-compose exec -T $(PHP_SERVICE) bin/console doctrine:migrations:migrate

########
# YARN #
########
yarn-install:
	@docker-compose exec -T $(PHP_SERVICE) yarn install

encore-build:
	@docker-compose exec -T $(PHP_SERVICE) yarn encore dev

encore-watch:
	@docker-compose exec -T $(PHP_SERVICE) yarn encore dev --watch

#########
# TOOLS #
#########
phpstan:
	@docker-compose exec -T $(PHP_SERVICE) vendor/bin/phpstan analyse -l 8 src --memory-limit=4G

php-cs-fixer:
	@docker-compose exec -T $(PHP_SERVICE) vendor/bin/php-cs-fixer fix -v --dry-run

php-cs-fixer-fix:
	@docker-compose exec -T $(PHP_SERVICE) vendor/bin/php-cs-fixer fix -v

###########
# GLOBALS #
###########
install: build composer-install

