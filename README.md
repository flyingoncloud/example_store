# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
0 RVM and ruby installation

sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | sudo bash -s stable

1 Ruby, rubygems and bundle 

rvm install ruby-2.3.3
rvm use 2.3.3 --default


sudo yum install rubygems
gem install bundle

2 Run application

bundle install
rake db:setup

rails server
