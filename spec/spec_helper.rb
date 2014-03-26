require 'active_record'
require 'shoulda-matchers'
require 'rspec'

require 'survey'
require 'taker'
require 'question'
require 'response'
require 'answer'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSpec.configure do |config|
  config.after(:each) do
    Survey.all.each { |survey| survey.destroy }
    Taker.all.each { |taker| taker.destroy }
  end
end
