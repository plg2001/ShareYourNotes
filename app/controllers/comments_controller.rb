class CommentsController < ApplicationController
    def create
      @note = Note.find(params[:note_id])
      @comment = @note.comments.build(comment_params)
      @comment.user = current_user
      @comment.content = params[:comment][:content]
      if @comment.content.strip != ''
        if @comment.save
          redirect_to @note, notice: 'Comment added successfully!'
        else
          redirect_to @note, alert: 'Failed to add comment.'
        end
      else
        redirect_to @note, alert: 'Failed to add comment.'
      end
    end
  
    def destroy
      @comment = Comment.find(params[:id])
      @comment.destroy
      redirect_to @comment.note, notice: 'Comment deleted successfully!'
    end
  
    private
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  end