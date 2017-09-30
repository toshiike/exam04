class StudysheetsController < ApplicationController
before_action :authenticate_user!
before_filter :authenticate_user!
before_action :set_studysheet, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.admin == true
      @studysheets = Studysheet.all.order(created_at: :desc)
    else
      @studysheets = current_user.studysheets.all.order(created_at: :desc)
    end
  end

  def show
    if current_user.admin == true
      @comment = @studysheet.comments.build
      @comments = @studysheet.comments
      Notification.find(params[:notification_id]).update(read: true) if params[:notification_id]
    else
      if @studysheet.user != current_user
        redirect_to studysheets_path, notice: "作成者しか閲覧できません"
      else
      @comment = @studysheet.comments.build
      @comments = @studysheet.comments
      Notification.find(params[:notification_id]).update(read: true) if params[:notification_id]
      end
    end
  end

  def new
    if params[:back]
      @studysheet = Studysheet.new(studysheets_params)
    else
      @studysheet = Studysheet.new
    end
  end

  def create
    @studysheet = Studysheet.create(studysheets_params)
    @studysheet.user_id = current_user.id
    if @studysheet.save
      redirect_to studysheets_path, notice: "作成しました！"
      NoticeMailer.sendmail_studysheet(@studysheet).deliver
    else
      render 'new'
    end
  end

  def edit
    #    @studysheet = Studysheet.find(params[:id])
    if @studysheet.user != current_user
      redirect_to studysheets_path, notice: "作成者しか編集できません"
    end
  end

  def update
#    @studysheet = Studysheet.find(params[:id])
  if @studysheet.user != current_user
    redirect_to studysheets_path, notice: "作成者しか更新できません"
  else
    if @studysheet.update(studysheets_params)
    redirect_to studysheets_path, notice: "更新しました！"
    else
      render 'edit'
    end
  end
  end

  def confirm
    @studysheet = Studysheet.new(studysheets_params)
    render :new if @studysheet.invalid?
  end

  def destroy
#    @studysheet = Studysheet.find(params[:id])
  if @studysheet.user != current_user
    redirect_to studysheets_path, notice: "作成者しか削除できません"
  else
    @studysheet.destroy
    redirect_to studysheets_path, notice: "削除しました！"
  end
  end

  def download
       @studysheet = Studysheet.find(params[:id])
       filepath = @studysheet.image.current_path
       stat = File::stat(filepath)
       sheet=@studysheet.image.url.gsub(/.*\//,'')
       send_file(filepath, :filename => sheet, :length => stat.size)
  end

  private
    def studysheets_params
      params.require(:studysheet).permit(:title, :content, :image, :image_cache)
    end

    def set_studysheet
        @studysheet = Studysheet.find(params[:id])
    end
end
