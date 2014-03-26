class Response < ActiveRecord::Base
  belongs_to :taker
  belongs_to :question
  belongs_to :answer

end
