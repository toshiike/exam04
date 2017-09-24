class AddUserIdToStudysheets < ActiveRecord::Migration
  def change
    add_column :studysheets, :user_id, :integer
  end
end
