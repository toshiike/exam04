class StudysheetsController < ApplicationController
before_action :authenticate_user!
before_action :set_studysheet, only: [:edit, :update, :destroy]

  def index
    @studysheets = Studysheet.all
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
  end

  def update
#    @studysheet = Studysheet.find(params[:id])
    if @studysheet.update(studysheets_params)
    redirect_to studysheets_path, notice: "更新しました！"
    else
      render 'edit'
    end
  end

  def confirm
    @studysheet = Studysheet.new(studysheets_params)
    render :new if @studysheet.invalid?
  end

  def destroy
#    @studysheet = Studysheet.find(params[:id])
    @studysheet.destroy
    redirect_to studysheets_path, notice: "削除しました！"
  end

  def download
       @studysheet = Studysheet.find(params[:id])
       filepath = @studysheet.image.current_path
       stat = File::stat(filepath)
       send_file(filepath, :filename => @studysheet.image.url.gsub(/.*\//,''), :length => stat.size)
  end

  private
    def studysheets_params
      params.require(:studysheet).permit(:title, :content, :image, :image_cache)
    end

    def set_studysheet
        @studysheet = Studysheet.find(params[:id])
    end
end
