class CreatePersonalizedCurriculums < ActiveRecord::Migration[5.0]
  def change
    create_table :personalized_curriculums do |t|
      t.string :name
      t.string :curriculum
      t.integer :student_import_id

      t.timestamps
    end
  end
end
