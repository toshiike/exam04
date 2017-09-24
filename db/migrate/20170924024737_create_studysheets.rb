class CreateStudysheets < ActiveRecord::Migration
  def change
    create_table :studysheets do |t|
      t.string :title
      t.text :content

      t.timestamps null: false
    end
  end
end
