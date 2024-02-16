class EntrySheetCommentController < ApplicationController
  before_action :set_entry_sheet_comment, only: %i[ show update destroy ] 

  # GET /entry_sheet_comments
  def index
    @entry_sheet_comments = EntrySheetComment.all

    render json: @entry_sheet_comments
  end

  # GET /entry_sheet_comments/1
  def show
    render json: @entry_sheet_comment
  end

  # POST /entry_sheet_comments
  def create
    @entry_sheet_comment = EntrySheetComment.new(entry_sheet_comment_params)

    if @entry_sheet_comment.save
      render json: @entry_sheet_comment, status: 200, location: @entry_sheet_comment
    else
      render json: @entry_sheet_comment.errors, status: 422
    end
  end

  # PATCH/PUT /entry_sheet_comments/1
  def update
    if @entry_sheet_comment.update(entry_sheet_comment_params)
      render json: @entry_sheet_comment
    else
      render json: @entry_sheet_comment.errors, status: 422
    end
  end

  # DELETE /entry_sheet_comments/1
  def destroy
    @entry_sheet_comment.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry_sheet_comment
      @entry_sheet_comment = EntrySheetComment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def entry_sheet_comment_params
      # params.fetch(:user, {})
      params.require(:entry_sheet_comment).permit!
    end
end
