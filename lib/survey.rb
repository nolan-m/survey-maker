class Survey < ActiveRecord::Base
  has_many :questions
  has_many :answers, through: :questions
  has_and_belongs_to_many :takers
end
