It's basic sinatra application for the Bird API

Steps to setup:

Firstly install the rvm from ruby version manager along with ruby 2.3.2 or greater version.

Once done with the the installation 

gem install bundler 

bundle install

then to execute the code

Run

ruby server.rb

Before running server you must have mongodb installed and running in your machine.


To check API you can use curl to follow sample request

 curl -i -X POST -H "Content-Type: application/json" -d'{"name":"The Power Of Habit","family":"sdsds","continents":["1","2"]}' http://localhost:4567/api/v1/birds 

 To check test cases just execute: ruby server_test.rb








