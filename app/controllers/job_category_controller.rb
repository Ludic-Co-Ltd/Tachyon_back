class JobCategoryController < ApplicationController
  before_action :set_job_category, only: %i[ show update destroy ] 

  # GET /job_categories
  def index
    @job_categories = JobCategory.all

    render json: @job_categories
  end

  # GET /job_categories/1
  def show
    render json: @job_category
  end

  # POST /job_categories
  def create
    @job_category = JobCategory.new(job_category_params)

    if @job_category.save
      render json: @job_category, status: 200, location: @job_category
    else
      render json: @job_category.errors, status: 422
    end
  end

  # PATCH/PUT /job_categories/1
  def update
    if @job_category.update(job_category_params)
      render json: @job_category
    else
      render json: @job_category.errors, status: 422
    end
  end

  # DELETE /job_categories/1
  def destroy
    @job_category.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_category
      @job_category = JobCategory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def job_category_params
      # params.fetch(:user, {})
      params.require(:job_category).permit!
    end
end
