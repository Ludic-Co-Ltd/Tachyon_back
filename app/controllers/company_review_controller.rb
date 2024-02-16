class CompanyReviewController < ApplicationController
    before_action :set_company_review, only: %i[  update destroy ] 
  before_action :authenticate_request!, only: %i[ create user_reservations] 
  # GET /company_reviews
  def index
    @company_reviews = CompanyReview.all

    render json: @company_reviews
  end

  def user_reservations
    begin 
          
      today = Date.today
      ten_days_later = today + 10.days

      @company_reviews = CompanyReview.select(:user_id, :event_id).where(user_id: current_user.id)
      
      ids = []
      for er in @company_reviews
        ids.push(er.event_id)
      end
      
      @events = Event.select(:id, :image_path, :name, :event_date, :start_time, :end_time, :zoom_url, :open_chat_url, :rating)
                            .where(id: ids, event_date: today..ten_days_later ).order(event_date: :asc)

      render json: @events, status: 200
    
    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  # GET /company_reviews/1
  def show

    begin 
          
      @company_reviews = CompanyReview.where(company_id: params[:id])         

      render json: @company_reviews, status: 200
    
    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end

  end

  # POST /company_reviews
  def create
    @company_review = CompanyReview.new({
      user_id: current_user.id,
      company_id: params[:company_id],
      title: params[:title],
      content: params[:content]
    })

    if @company_review.save
      render json: @company_review, status: 200
    else
      render json: @company_review.errors, status: 422
    end
  end

  # PATCH/PUT /company_reviews/1
  def update
    if @company_review.update(company_review_params)
      render json: @company_review
    else
      render json: @company_review.errors, status: 422
    end
  end

  # DELETE /company_reviews/1
  def destroy
    @company_review.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_review
      @company_review = CompanyReview.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def company_review_params
      # params.fetch(:user, {})
      params.require(:company_review).permit!
    end
end
