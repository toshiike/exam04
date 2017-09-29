class CommentsController < ApplicationController
  # コメントを保存、投稿するためのアクションです。
  def create
    # studysheetをパラメータの値から探し出し,studysheetに紐づくcommentsとしてbuildします。
    @comment = current_user.comments.build(comment_params)
    @studysheet= @comment.studysheet
    @notification = @comment.notifications.build(user_id: @studysheet.user.id )
    # クライアント要求に応じてフォーマットを変更
    respond_to do |format|
      if @comment.save
        format.html { redirect_to studysheet_path(@studysheet), notice: 'コメントを投稿しました。' }
          # JS形式でレスポンスを返します。
        format.js { render :index }
       unless @comment.studysheet.user_id == current_user.id
        Pusher.trigger("user_#{@comment.studysheet.user_id}_channel", 'comment_created', {
          message: 'あなたの作成したブログにコメントが付きました'
        })
      end
      Pusher.trigger("user_#{@comment.studysheet.user_id}_channel", 'notification_created', {
        unread_counts: Notification.where(user_id: @comment.studysheet.user.id, read: false).count
        })
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @studysheet = @comment.studysheet
    respond_to do |format|
      @comment.destroy
      format.html { redirect_to studysheet_path(@studysheet), notice: 'コメントを削除しました。' }
      format.js { render :index }
      end
  end

  def edit
    @comment = Comment.find(params[:id])
    @studysheet = @comment.studysheet
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      redirect_to studysheet_path(@comment.studysheet), notice: 'コメントを更新しました。'
    else
      render 'edit'
    end
  end

  private
    # ストロングパラメーター
    def comment_params
      params.require(:comment).permit(:studysheet_id, :content)
    end
end
