class Taker < ActiveRecord::Base
  has_many :responses
  has_and_belongs_to_many :surveys
  has_many :answers, through: :responses
  has_many :questions, through: :responses
end
