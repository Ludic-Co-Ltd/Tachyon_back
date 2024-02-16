class EntrySheetHistoryController < ApplicationController
  before_action :set_entry_sheet_history, only: %i[ show update destroy ] 

  # GET /entry_sheet_histories
  def index
    @entry_sheet_histories = EntrySheetHistory.all

    render json: @entry_sheet_histories
  end

  # GET /entry_sheet_histories/1
  def show
    render json: @entry_sheet_history
  end

  # POST /entry_sheet_histories
  def create
    @entry_sheet_history = EntrySheetHistory.new(entry_sheet_history_params)

    if @entry_sheet_history.save
      render json: @entry_sheet_history, status: 200, location: @entry_sheet_history
    else
      render json: @entry_sheet_history.errors, status: 422
    end
  end

  # PATCH/PUT /entry_sheet_histories/1
  def update
    if @entry_sheet_history.update(entry_sheet_history_params)
      render json: @entry_sheet_history
    else
      render json: @entry_sheet_history.errors, status: 422
    end
  end

  # DELETE /entry_sheet_histories/1
  def destroy
    @entry_sheet_history.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry_sheet_history
      @entry_sheet_history = EntrySheetHistory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def entry_sheet_history_params
      # params.fetch(:user, {})
      params.require(:entry_sheet_history).permit!
    end
end
