class PersonalizedCurriculumsController < ApplicationController
  def show
    @personalized_curriculums = PersonalizedCurriculum.where(student_import_id: params[:student_import_id])
  end
end
