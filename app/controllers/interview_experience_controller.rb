class InterviewExperienceController < ApplicationController
  before_action :set_interview_experience, only: %i[ show update destroy ] 

  # GET /interview_experiences
  def index
    @interview_experiences = InterviewExperience.all

    render json: @interview_experiences
  end

  # GET /interview_experiences/1
  def show
    render json: @interview_experience
  end

  # POST /interview_experiences
  def create
    @interview_experience = InterviewExperience.new(interview_experience_params)

    if @interview_experience.save
      render json: @interview_experience, status: 200, location: @interview_experience
    else
      render json: @interview_experience.errors, status: 422
    end
  end

  # PATCH/PUT /interview_experiences/1
  def update
    if @interview_experience.update(interview_experience_params)
      render json: @interview_experience
    else
      render json: @interview_experience.errors, status: 422
    end
  end

  # DELETE /interview_experiences/1
  def destroy
    @interview_experience.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interview_experience
      @interview_experience = InterviewExperience.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def interview_experience_params
      # params.fetch(:user, {})
      params.require(:interview_experience).permit!
    end
end
