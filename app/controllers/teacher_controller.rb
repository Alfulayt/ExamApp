# frozen_string_literal: true

class TeacherController < ApplicationController
  before_action :authenticate_user!
  before_action :is_teacher

  def is_teacher
    redirect_to root_path, notice: 'not allowed!' if current_user.teacher? == false
  end
end