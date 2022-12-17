# README

* Ruby 3.1.0
* Rails 7.0.4

## LOCAL

* bundle install
* rails db:create db:migrate

## RSPEC

* bundle exec rspec spec

## API

* https://glacial-tor-44611.herokuapp.com/api/v1
* /users
* /lists
* /lists/:list_id/list_items

## POSSIBLE NEXT IMPROVEMENTS

* move authentication to a service
* install devise to deal with user sessions properly
* install rubocop to help on "ruby's way"
* make jwt work alongside with devise
* create a background job to cleanup blacklisted_tokens table from time to time
* create views, maybe using react
* create more meaninful test cases and some edge cases as well
* create a proper api documentation 
