require 'csv'

class StudentImportsController < ApplicationController
  def index
    @student_imports = StudentImport.all
  end

  def new
  end

  def import
    domain_order = params[:domain_order].read
    student_tests = params[:student_tests].read

    @student_import = StudentImport.new(
      domain_order: domain_order,
      student_tests: student_tests
      )

    if @student_import.save
      create_personalized_curriculum(
        domain_parse(domain_order), 
        test_parse(student_tests), 
        @student_import.id, 
        5
        )

      redirect_to '/student_imports'
    else
      redirect_to '/student_imports/new'
    end
  end

  private

    #Takes in domain_order text and parses it into a hash with grades as the key
    def domain_parse(domain_text)
      domain_order = {}

      CSV.parse(domain_text).each do |order|
        domain_order[order.shift] = order
      end

      domain_order
    end

    #Takes in the student_tests text and converts it to a hash
    def test_parse(test_text)
      student_grades = []

      CSV.parse(test_text, headers: true).each do |row|
        student_grades << row.to_h
      end

      student_grades
    end

    #Creates personalized curriculum
    def create_personalized_curriculum(domain_order, student_grades, import_id, limit)
      student_grades.each do |student_grade|

        @curriculum = ""
        @limit_counter = 0

        domain_order.each do |key, value|
          value.each do |order|

            if student_grade[order].to_i <= key.to_i

              if @limit_counter == 0
                @curriculum << "#{key}.#{order}"

                if key == "K"
                  student_grade[order] = "1"
                else
                  student_grade[order] = "#{key.to_i+1}"
                end

                @limit_counter += 1
              elsif @limit_counter < limit
                @curriculum << ",#{key}.#{order}"

                if key == "K"
                  student_grade[order] = "1"
                else
                  student_grade[order] = "#{key.to_i+1}"
                end

                @limit_counter += 1
              end

            end
          end
        end

        PersonalizedCurriculum.create(
          name: student_grade["Student Name"], 
          curriculum: @curriculum, 
          student_import_id: import_id
          )

        @curriculum = ""
        @limit_counter = 0
      end
    end
end
