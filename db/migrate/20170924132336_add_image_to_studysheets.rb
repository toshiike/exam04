class AddImageToStudysheets < ActiveRecord::Migration
  def change
    add_column :studysheets, :image, :string
  end
end
