require 'rails_helper'


describe 'Tests Api', type: :request do

  before do
    @test = Test.first
  end

  it 'return all available tests' do
    get '/api/v1/tests', headers: @headers
    expect(response).to have_http_status(:success)
    body = JSON.parse(response.body)
    expect(body['test'].size).to eq(3)
  end

  it 'get tests list when user not logged in' do
    get '/api/v1/tests'
    expect(response.status).to eq(401)
  end

  it 'get test details' do
    get "/api/v1/tests/#{@test.id}/questions", headers: @headers
    expect(response).to have_http_status(:success)
    body = JSON.parse(response.body)
    expect(body['test_title']).to eq(@test.title)
    expect(body['test_description']).to eq(@test.description)
  end

  it 'get test questions' do
    get "/api/v1/tests/#{@test.id}/questions", headers: @headers
    expect(response).to have_http_status(:success)
    body = JSON.parse(response.body)
    questions = @test.questions.first
    expect(body['questions'].first['title']).to eq(questions.title)
    expect(body['questions'].first['description']).to eq(questions.description)
  end

  it 'get test question options' do
    get "/api/v1/tests/#{@test.id}/questions", headers: @headers
    expect(response).to have_http_status(:success)
    body = JSON.parse(response.body)
    questions = @test.questions.first
    options = questions.question_option.first
    expect(body['questions'].first['options'].first['title']).to eq(options.title)
  end


  it 'check test details with wrong Id' do
    get "/api/v1/tests/-1/questions", headers: @headers
    expect(response.status).to eq(404)
    body = JSON.parse(response.body)
    expect(body['status']).to eq("failed")
    expect(body['message']).to eq("404 Not Found")
  end

end
