require 'csv'

class StudentImport < ApplicationRecord
  has_many :personalized_curriculums
end
