module StudysheetsHelper
  def choose_new_or_edit
     if action_name == 'new' || action_name == 'confirm'
       confirm_studysheets_path
     elsif action_name == 'edit'
       studysheet_path
     end
   end
end
