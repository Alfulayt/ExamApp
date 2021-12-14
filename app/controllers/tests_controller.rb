# frozen_string_literal: true

class TestsController < TeacherController

  def index
    @tests = Test.all
  end

  def show
    @test = Test.find(params[:id])

  end

  def new
    @test = Test.new
  end

  def create
    @test = Test.new(test_params)
    @test.save

    ActiveRecord::Base.transaction do
      questions_param.require(:questions).each do |question|
        created_question = create_question(@test, question) if @test.persisted?
        question[:options].each do |option|
          create_question_option(created_question, option) if created_question.persisted?
        end
      end
    end

    if @test
      redirect_to @test
    else
      render :new
    end

  end

  def create_question(test, question)
    test.questions.create!(
      test_id: test.id,
      title: question[:title],
      description: question[:description]
    )
  end

  def create_question_option(question, option)
    question.question_option.create!(
      question_id: question.id,
      title: option[:title],
      correct: option[:correct]
    )
  end

  def edit
    @test = Test.find(params[:id])
    @questions = @test.questions.map(&:with_options).to_json
  end

  def update
    @test = Test.find(params[:id])
    # TODO: fetch all edited questions and options if it's had id -> update , doesn't have -> create
    if @test.update(test_params)

      redirect_to @test
    else
      render :edit
    end
  end

  def destroy
    @test = Test.find(params[:id])
    @test.destroy

    redirect_to tests_path
  end

  private

  def questions_param
    params.permit(questions: [:title, :description, { options: [:title, { correct: %i[key value] }] }])
  end

  def test_params
    params.require(:test).permit(:title, :description)
  end

end
