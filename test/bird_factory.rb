require_relative 'test_helper'
require 'test/unit'
require 'rack/test'
require 'factory_girl'


FactoryGirl.define do
  factory :bird do
    name 'Marty McSpy'
    family 'Hoverboard'
    continents ['Infiltration and espionage']
    visible true
  end 
end