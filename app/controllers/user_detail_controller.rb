class UserDetailController < ApplicationController
  before_action :set_user_detail, only: %i[ show update destroy ] 

  # GET /user_details
  def index
    @user_details = UserDetail.all

    render json: @user_details
  end

  # GET /user_details/1
  def show
    render json: @user_detail
  end

  # POST /user_details
  def create
    @user_detail = UserDetail.new(user_detail_params)

    if @user_detail.save
      render json: @user_detail, status: 200, location: @user_detail
    else
      render json: @user_detail.errors, status: 422
    end
  end

  # PATCH/PUT /user_details/1
  def update
    if @user_detail.update(user_detail_params)
      render json: @user_detail
    else
      render json: @user_detail.errors, status: 422
    end
  end

  # DELETE /user_details/1
  def destroy
    @user_detail.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_detail
      @user_detail = UserDetail.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_detail_params
      # params.fetch(:user, {})
      params.require(:user_detail).permit!
    end
end
