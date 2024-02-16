class CaseStudyController < ApplicationController
  before_action :set_case_study, only: %i[ show update destroy ] 
  before_action :admin_request!, only: %i[ create ] 
  before_action :authenticate_request!, only: %i[ case_today mycases cases3 myeditcases] 

  # GET /case_studies
  def index
    begin 
      @case_studies = CaseStudy.all
      render json:@case_studies.to_json(except: [ :created_at, :updated_at, :deleted_at]), status:200
    rescue => error
      render json: {error: 'リソースが存在しません'}, status: 404
    end
  end  

  def case_today
    begin 
      # @case_studies = CaseStudy.all
      # render json:@case_studies.to_json(except: [ :created_at, :updated_at, :deleted_at]), status:200
     
      @cast_today = CaseStudyComment.where(user_id: current_user.id)

      ids=[]
      for er in @cast_today
        ids.push(er.case_study_id)
      end
      @cast_today = CaseStudy.where.not(id: ids)
                .order(updated_at: :desc)
                .last

      render json: @cast_today, status:200

    rescue => error
      puts error
      render json: {error: 'リソースが存在しません'}, status: 404
    end
  end

  def myeditcases
    begin 
      # @events = Event.includes(:company).order(event_date: :desc)
      # render json: @events.to_json(include: [:company=>{only: [:id, :name]}]), status:200
      results = []
      @my_cases = CaseStudy.includes(:company, :case_study_comments).where(deleted_at: nil).order(updated_at: :desc)
      for mc in @my_cases
             
        csc = CaseStudyComment.where(case_study_id: mc.id).where(user_id: current_user.id).first
        if csc
          result = {}
          result[:case_study]= mc
          result[:thumbnail]= csc.thumbnail   
          result[:file_path] = csc.file_path
          result[:company]= mc.company.name   
          result[:mark1]= csc.mark1
          result[:mark2] = csc.mark2
          result[:mark3] = csc.mark3
          result[:mark4] = csc.mark4
          result[:comment_id] = csc.id          
          result[:published_date] = csc.created_at
          results.push(result)
        end
        
      end
      puts results
      render json: results, status:200     

    rescue => error
      puts error
      render json: {error: 'リソースが存在しません'}, status: 404
    end

  end

  def mycases
    begin 
      # @events = Event.includes(:company).order(event_date: :desc)
      # render json: @events.to_json(include: [:company=>{only: [:id, :name]}]), status:200
      # results = []
      # @my_cases = CaseStudy.includes(:company, :case_study_comments).where(deleted_at: nil).order(updated_at: :desc)
      # for mc in @my_cases
      #   result = {}
      #   result[:case_study]= mc
      #   result[:company]= mc.company.name        
      #   csc = CaseStudyComment.where(case_study_id: mc.id).where(user_id: current_user.id).first
      #   if csc
      #     result[:mark1]= csc.mark1
      #     result[:mark2] = csc.mark2
      #     result[:mark3] = csc.mark3
      #     result[:mark4] = csc.mark4
      #     result[:comment_id] = csc.id
      #     result[:published_date] = csc.created_at
      #   end
      #   results.push(result)
      # end
      # puts results
      # render json: results, status:200

      @case_study = CaseStudyComment.where(user_id: current_user.id)

      ids=[]
      for er in @case_study
        ids.push(er.case_study_id)
      end

      @case_study = CaseStudy.includes(:company).where.not(id: ids)
                .order(updated_at: :desc)

      render json: @case_study.to_json(include: [:company=>{only: [:id, :name]}]), status:200

    rescue => error
      puts error
      render json: {error: 'リソースが存在しません'}, status: 404
    end

  end

  def cases3
    begin 
      # @events = Event.includes(:company).order(event_date: :desc)
      # render json: @events.to_json(include: [:company=>{only: [:id, :name]}]), status:200
      results = []
      @my_cases = CaseStudy.includes(:company, :case_study_comments).where(deleted_at: nil).order(updated_at: :desc)
      cnt = 0
      for mc in @my_cases
             
        csc = CaseStudyComment.where(case_study_id: mc.id).where(user_id: current_user.id).first
        if csc
          
          if cnt > 2
            break
          end

          result = {}
          result[:case_study]= mc
          result[:thumbnail]= csc.thumbnail   
          result[:file_path] = csc.file_path
          result[:company]= mc.company.name   
          result[:mark1]= csc.mark1
          result[:mark2] = csc.mark2
          result[:mark3] = csc.mark3
          result[:mark4] = csc.mark4
          result[:comment_id] = csc.id          
          result[:published_date] = csc.created_at
          results.push(result)
          
          cnt = cnt + 1
        end
        
      end
      
      render json: results, status:200     

    rescue => error
      puts error
      render json: {error: 'リソースが存在しません'}, status: 404
    end
  end

  # GET /case_studies/1
  def show
    begin 
  
    #   @case_study = CaseStudy.includes(:companies).find(params[:id])

    #   render json: @case_study.to_json(include: [:case_study=>{only: [:id, :name]}]), status:200

       @case_study = CaseStudy.includes(:company).find(params[:id])
      render json: @case_study.to_json(include: [:company=>{only: [:id, :name]}]), status:200

    rescue => error   
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  # POST /case_studies
  def create
    materials_path = upload_file(params[:material])
    @case_study = CaseStudy.new({
        company_id: params[:company_id],
        mentor_id: params[:mentor_id],
        thinking_time: params[:thinking_time],
        materials_path: materials_path,
        question: params[:question],
        content: params[:content],
        start_date: params[:start_date],
        end_date: params[:end_date],
        industry_id: 1,
        is_undisclosed: 0,
        status: 0,
      })

    if @case_study.save
      render json: @case_study, status: 200
    else
      render json: @case_study.errors, status: 422
    end
  end

  # POST /case_studies/today/save
  # Moon 1/11

  # PATCH/PUT /case_studies/1
  def update
    puts params[:material]
    if params[:material]
      material_file = params[:material]
      materials_path = upload_file(material_file)
      @case_study.materials_path = materials_path
    end
    
    @case_study.company_id = params[:company_id]
    @case_study.mentor_id = params[:mentor_id]
    @case_study.thinking_time = params[:thinking_time]
    @case_study.question = params[:question]
    @case_study.content = params[:content]
    @case_study.start_date = params[:start_date]
    @case_study.end_date = params[:end_date]
    @case_study.industry_id = 1
    @case_study.is_undisclosed = 0
    @case_study.status = 0

    # if @case_study.update(case_study_params)
    if @case_study.save
      render json: @case_study, status: 200
    else
      render json: @case_study.errors, status: 422
    end
  end

  # PUT /case_studies/public/1
  def public
    @case_study = CaseStudy.find(params[:id])
    puts @case_study.is_undisclosed
    @case_study[:is_undisclosed] ^= 1 
    if @case_study.save
      @case_studies = CaseStudy.all
      render json: @case_studies.to_json(except: [ :created_at, :updated_at, :deleted_at]), status:200
      # render json: @case_study, status: 200
    else
      render json: @case_study.errors, status: 422
    end
  end

  # DELETE /case_studies/1
  def destroy
    @case_study.destroy!
    render json: @case_study, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_case_study
      @case_study = CaseStudy.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def case_study_params
      # params.fetch(:user, {})
      puts 'case_study_params'
      params.require(:case_study).permit!
    end

    def upload_file(file)
      # Define the specific path where you want to save the file
      ext = File.extname(file.original_filename)
      now=Time.now.strftime("%Y%m%d_%H%M%S")
      FileUtils.mkdir_p(Rails.root.join('public', 'uploads','case_studies')) unless
      File.directory?(Rails.root.join('public', 'uploads','case_studies'))
      specific_path = Rails.root.join('public', 'uploads','case_studies', now+ext)

      # Save the file to the specific path
      File.open(specific_path, 'wb') do |f|
        f.write(file.read)
      end
      return specific_path.to_s.split("public/")[1]
    end
end
