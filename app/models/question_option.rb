class QuestionOption < ApplicationRecord
  belongs_to :question

  def as_json(options = {})
    super(options.merge({ except: [:created_at,:updated_at,:question_id] }))
  end

  def questions_only
    {
      id: id,
      title: title
    }
  end

end
