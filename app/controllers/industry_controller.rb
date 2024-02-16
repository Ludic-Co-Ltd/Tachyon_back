class IndustryController < ApplicationController
  before_action :set_industry, only: %i[ show update destroy ] 

  # GET /industries
  def index
    begin

      @industries = Industry.select(:id, :name).includes(:companies)
  
      render json: @industries.to_json(include: [:companies=>{only: [:id,:name, :industry_id, :logo_path]}]), status:200

    rescue => error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  # GET /industries/1
  def show
    render json: @industry
  end

  # POST /industries
  def create
    @industry = Industry.new({
      name:params[:name]
    })

    if @industry.save
      render json: @industry, status: 200
    else
      render json: @industry.errors, status: 422
    end
  end

  # PATCH/PUT /industries/1
  def update
    if @industry.update(industry_params)
      render json: @industry
    else
      render json: @industry.errors, status: 422
    end
  end

  # DELETE /industries/1
  def destroy
    @industry.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_industry
      @industry = Industry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def industry_params
      # params.fetch(:user, {})
      params.require(:industry).permit!
    end
end
