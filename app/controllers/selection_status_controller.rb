class SelectionStatusController < ApplicationController
  before_action :set_selection_status, only: %i[ show update destroy ] 

  # GET /selection_statuses
  def index
    @selection_statuses = UserDetail.all

    render json: @selection_statuses
  end

  # GET /selection_statuses/1
  def show
    render json: @selection_status
  end

  # POST /selection_statuses
  def create
    @selection_status = UserDetail.new(selection_status_params)

    if @selection_status.save
      render json: @selection_status, status: 200, location: @selection_status
    else
      render json: @selection_status.errors, status: 422
    end
  end

  # PATCH/PUT /selection_statuses/1
  def update
    if @selection_status.update(selection_status_params)
      render json: @selection_status
    else
      render json: @selection_status.errors, status: 422
    end
  end

  # DELETE /selection_statuses/1
  def destroy
    @selection_status.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_selection_status
      @selection_status = SelectionStatus.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def selection_status_params
      # params.fetch(:user, {})
      params.require(:selection_status).permit!
    end
end
