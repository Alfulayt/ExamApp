# frozen_string_literal: true

module Api
  module V1
    class TestsController < Api::V1::ApplicationController

      before_action :authenticate_api_user!

      def index
        tests = Test.all
        render_success_response({ test: tests })
      end

      def questions
        test = Test.find(params[:id])
        questions = test.questions.map(&:with_options)
        render_success_response({
                                  test_title: test.title,
                                  test_description: test.description,
                                  questions: questions
                                })
      end

      def take_test
        test = Test.find(params[:id])

        result ||= []
        total_score = 0
        test_answers_params[:question_answers].each do |answer|
          question = test.questions.find(answer[:question_id])
          get_answer = QuestionOption.where(id: answer[:answer_id]).first
          correct_answer = get_answer.nil? ? false : get_answer.correct?
          total_score += 1 if correct_answer
          question_result = {
            question: question.title,
            is_correct: correct_answer
          }
          result.push(question_result)
        end
        final_result = {
          total_score: total_score,
          out_of: test.questions.count
        }
        render_success_response({
                                  test_result: result,
                                  final_result: final_result
                                })
      end

      private

      def test_answers_params
        params.permit(question_answers: %i[question_id answer_id])
      end


    end
  end
end
