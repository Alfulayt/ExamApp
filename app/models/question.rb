class Question < ApplicationRecord
  belongs_to :test
  has_many :question_option, dependent: :destroy

  def with_options
    {
      id: id,
      title: title,
      description: description,
      options: question_option.map(&:questions_only)
    }
  end

  def with_options_correct
    {
      id: id,
      title: title,
      description: description,
      options: question_option
    }
  end

end
