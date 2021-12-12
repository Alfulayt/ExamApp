class Question < ApplicationRecord
  belongs_to :test
  has_many :question_option
end
