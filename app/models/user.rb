class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
  enum role: [ :teacher, :student ]

  validates :name, presence: true
  validates :email, presence: true
  validates :password,
            confirmation: true,
            if: -> { new_record? || !password.blank? }
  validates :password_confirmation,
            presence: true,
            if: -> { new_record? || !password_confirmation.blank? }
  validates :role, presence: true, inclusion: { in: roles }


end
