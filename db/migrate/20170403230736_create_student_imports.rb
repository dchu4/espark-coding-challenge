class CreateStudentImports < ActiveRecord::Migration[5.0]
  def change
    create_table :student_imports do |t|
      t.text :domain_order
      t.text :student_tests

      t.timestamps
    end
  end
end
