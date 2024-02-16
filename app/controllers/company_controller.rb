class CompanyController < ApplicationController
  before_action :set_company, only: %i[ show update destroy ] 

  # GET /companies
  def index
    begin
      # @companies = Industry.includes(:companies).select(:id,:name)
      # render json: @companies.to_json(
      #       include: [:companies=>{only: [:name, :logo_path]}]), status:200
      @companies = Company.includes(:industry).select(:id,:name, :industry_id)      
      render json: @companies.to_json(include: [:industry=>{only: [:id,:name]}]), status:200

    rescue => error
      render json: {error: 'サーバーエラー。', status: 500}
    end
  end

  # GET /companies/1
  def show
    begin
      @company = Company.find(params[:id])
      if @company
        render json: @company.to_json(except: [ :created_at, :updated_at, :deleted_at]), status:200
      else
        render json: {error: 'リソースが存在しません'}, status: 404
      end
    rescue => error
      render json: {error: 'リソースが存在しません'}, status: 404
    end
  end

  # POST /companies
  def create
    file = params[:logo]
    logo_path = upload_file(file)
    @company = Company.new({
      industry_id: params[:industry_id],
      name: params[:name],
      overview: params[:overview],
      logo_path: logo_path
    })

    if @company.save
      render json: @company, status: 200
    else
      render json: @company.errors, status: 422
    end
  end

  # PATCH/PUT /companies/1
  def update
    @company = Company.find(params[:id])

    if @company
      file = params[:logo]

      logo_path = file ? upload_file(file) : params[:logo_path]
      @company.industry_id = params[:industry_id]
      @company.name = params[:name]
      @company.overview = params[:overview]
      @company.logo_path = logo_path

      if @company.save
        render json: @company, status: 200
      else
        render json: @company.errors, status: 422
      end
    else
      render json: {error: 'リソースが存在しません'}, status: 422
    end  
  
  end

  # DELETE /companies/1
  def destroy
    @company.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def company_params
      # params.fetch(:user, {})
      params.require(:company).permit!
    end

    def upload_file(file)
    # Define the specific path where you want to save the file
      ext = File.extname(file.original_filename)
      now=Time.now.strftime("%Y%m%d_%H%M%S")
      FileUtils.mkdir_p(Rails.root.join('public', 'uploads','companies')) unless
      File.directory?(Rails.root.join('public', 'uploads','companies'))
      specific_path = Rails.root.join('public', 'uploads','companies', now+ext)

      # Save the file to the specific path
      File.open(specific_path, 'wb') do |f|
        f.write(file.read)
      end
      return specific_path.to_s.split("public/")[1]
    end
end
