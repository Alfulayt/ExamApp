class Test < ApplicationRecord
  has_many :questions , dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates_associated :questions
end
