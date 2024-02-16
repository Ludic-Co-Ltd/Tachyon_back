# require 'pdf/image'

class CaseStudyCommentController < ApplicationController
  before_action :set_case_study_comment, only: %i[ show update destroy ] 
  before_action :authenticate_request!, only: %i[ create challenges] 

  # GET /case_study_comments
  def index
    @case_study_comments = CaseStudyComment.all

    render json: @case_study_comments.to_json(include: [:case_study=>{only: [:id, :question,:status, :thinking_time, :content, :created_at]},
                      :user=>{only: [:id, :first_name,:last_name]}]), status: 200
  end

  # GET /case_study_comments/1
  def show
    begin 
  
      @case_study_comment = CaseStudyComment.includes(:case_study).find(params[:id])
      company = @case_study_comment.case_study.company
      render json: {case_study_comment:@case_study_comment.to_json(include: [:case_study=>{only: [:id, :question, :thinking_time]}]), company:company.name}, status:200
      # render json: @case_study_comment.to_json(include: {case_study=>[{only: [:id, :question,:company_id]},include:{:company=>{only: [:id, :name]}}]}), status:200
      # render json: @case_study_comment.to_json(include: {case_study => {include: :company}}), status:200

    rescue => error   
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
    # render json: @case_study_comment
  end
  #Moon 1.11
  def challenges
    begin  
      # get my challenges 
      # @challenges = CaseStudyComment.includes(:case_study).select(:id,:comment, :file_path, :case_study_id, :user_id).where(user_id: current_user.id)

      # get all challenges 
      @challenges = CaseStudyComment.includes(:case_study).where("mark1 > 0")

      render json: @challenges.to_json(include: [:case_study=>{only: [:id, :question]}]), status:200

    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
    # render json: @case_study_comment
  end

  # POST /case_study_comments
  def create
    begin
      image = params[:file_path]
      file_path = upload_file(image)
      
      @case_study_comment = CaseStudyComment.new({
        case_study_id: params[:id],
        user_id: current_user.id,
        comment: '',
        file_path: file_path,
        thumbnail: file_path.gsub('.pdf', '.png'),
        mark1: '',
        mark2: '',
        mark3: '',
        mark4: '',
      })

      
      @user_ticket = UserTicket.new({
        user_id: current_user.id,
        event_ticket_number:0,
        case_ticket_number: -1,
        es_ticket_number: 0,
        interview_ticket_number: 0,
        bip_id: params[:id],
        status:3
      })     
      

      if @case_study_comment.save && @user_ticket.save
        render json: {case_study_comment:@case_study_comment, user_ticket:@user_ticket}, status: 200
      else
        render json: @case_study_comment.errors, status: 422
      end
    rescue =>error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  # PATCH/PUT /case_study_comments/1
  def update
    if @case_study_comment.update(case_study_comment_params)
      render json: @case_study_comment
    else
      render json: @case_study_comment.errors, status: 422
    end
  end

  # DELETE /case_study_comments/1
  def destroy
    @case_study_comment.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_case_study_comment
      @case_study_comment = CaseStudyComment.find(params[:id])
    end
    # Only allow a list of trusted parameters through.
    def case_study_comment_params
      # params.fetch(:user, {})
      params.require(:case_study_comment).permit!
    end

    def upload_file(file)
      # Define the specific path where you want to save the file
      ext = File.extname(file.original_filename)
      now=Time.now.strftime("%Y%m%d_%H%M%S")
      FileUtils.mkdir_p(Rails.root.join('public', 'uploads','case_study_comments')) unless
      File.directory?(Rails.root.join('public', 'uploads','case_study_comments'))
      specific_path = Rails.root.join('public', 'uploads','case_study_comments', now+ext)

      File.open(specific_path, 'wb') do |f|
        f.write(file.read)
      end
      require 'mini_magick'
      # Path to the input PDF file
      pdf_path = specific_path

      # Path to save the output image file
      output_image_path = Rails.root.join('public', 'uploads','case_study_comments', now+'.png')
      # Use MiniMagick to convert the first page of the PDF to an image
      image = MiniMagick::Image.open(pdf_path)
      image.format('png')
      image.page('1')
      image.resize('800x') # Resize the image if needed
      image.write(output_image_path)
      # result = {"file_path" => specific_path.to_s.split("public/")[1], "thumbnail" => output_image_path.to_s.split("public/")[1]}
      return specific_path.to_s.split("public/")[1]
    end
end
