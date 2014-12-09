# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'factory_girl_rails'

include ActionDispatch::TestProcess

FactoryGirl.create :user, email: 'admin@developmentbootcamp.nl'
FactoryGirl.create_list :sponsor, 5, :active
FactoryGirl.create_list :sponsor, 5, hiring: true
FactoryGirl.create_list :sponsor, 5, hiring: true
FactoryGirl.create_list :sponsor, 5, :active, hiring: true

FactoryGirl.create_list :sponsor, 2, :active, plan: 'platinum'
FactoryGirl.create_list :sponsor, 5, :active, plan: 'gold'
FactoryGirl.create_list :sponsor, 5, :active, plan: 'silver'
FactoryGirl.create_list :sponsor, 2, :active, plan: 'lunch'
FactoryGirl.create :sponsor, :active, plan: 'hackathon'
FactoryGirl.create :sponsor, :active, plan: 'party'