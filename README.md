# ADS

## Dependencies
* Ruby 2.6.3
* Bundler 2.1.4
* Sinatra 2.0.0
* Puma 4.3.0

## Installation
```
git clone git@github.com:natalya-bogdanova/ads_microservice.git && cd ads_microservice
bundle install
```
## DB preparation(via Docker)
```
docker run -d -p 5432:5432 --name auth_postgres -e POSTGRES_PASSWORD=password postgres

createdb -h localhost -U postgres ads_microservice_development
createdb -h localhost -U postgres ads_microservice_test

```

## Migrations and Seeds
```
bin/rake db:migrate
RACK_ENV=test bin/rake db:migrate

bin/rake db:seed
```

## Run application:
```
bin/puma
```

## Run specs and console
```
bin/console
bin/rspec
```
