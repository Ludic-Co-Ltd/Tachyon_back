class EntrySheetController < ApplicationController
  before_action :set_entry_sheet, only: %i[ show update destroy ] 
  before_action :authenticate_request!, only: %i[ create es3 myes] 
  before_action :admin_request!, only: %i[ destroy] 
  # GET /entry_sheets
  def index
    @entry_sheets = EntrySheet.where(deleted_at: nil)
    render json: @entry_sheets.to_json(include: [
      :user=>{only: [:first_name, :last_name]},
      :company=>{only: [:name]},
      ]), status:200
  end

  def es3
    @entry_sheets = EntrySheet.where(user_id: current_user.id).where(deleted_at: nil).limit(3)
    render json: @entry_sheets.to_json(except: [ :created_at, :updated_at, :deleted_at]), status:200
  end

  def myes
    # @events.to_json(include: [:company=>{only: [:id, :name]}]), status:200
    @entry_sheets = EntrySheet.where(user_id: current_user.id).where(deleted_at: nil)
    render json: @entry_sheets.to_json(include: [:company=>{only: [:id, :name]}]), status:200
  end

  # GET /entry_sheets/1
  def show
    render json: @entry_sheet.to_json(include: [:company=>{only: [:id, :name]}]), status:200
  end

  # POST /entry_sheets
  def create

    begin
      image = params[:file_path]
      file_path = upload_file(image)
      @entry_sheet = EntrySheet.new({        
        user_id: current_user.id,
        company_id: params[:company_id],
        period: params[:period],
        correction_result:'',
        content:'',
        status: 1,
        file_path: file_path,
        thumbnail: file_path.gsub('.pdf', '.png')
      })

      if @entry_sheet.save 
        @user_ticket = UserTicket.new({
          user_id: current_user.id,
          event_ticket_number:0,
          case_ticket_number: 0,
          es_ticket_number: -1,
          interview_ticket_number: 0,
          bip_id: @entry_sheet.id,
          status:3
        })
      end
      if @entry_sheet.save && @user_ticket.save
        render json: {entry_sheet:@entry_sheet, user_ticket:@user_ticket}, status: 200
      else
        puts @user_ticket.errors.messages
        render json: @entry_sheet.errors, status: 422
      end

    rescue =>error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  # PATCH/PUT /entry_sheets/1
  def update
    
    if @entry_sheet.update(entry_sheet_params.merge({status: 2}))
      render json: @entry_sheet
    else
      render json: @entry_sheet.errors, status: 422
    end
  end

  # DELETE /entry_sheets/1
  def destroy
    @entry_sheet.deleted_at = Time.now
    @entry_sheet.save
    render json: @entry_sheet, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry_sheet
      @entry_sheet = EntrySheet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def entry_sheet_params
      # params.fetch(:user, {})
      params.require(:entry_sheet).permit!
    end

    def upload_file(file)
      # Define the specific path where you want to save the file
      ext = File.extname(file.original_filename)
      now=Time.now.strftime("%Y%m%d_%H%M%S")
      FileUtils.mkdir_p(Rails.root.join('public', 'uploads','es')) unless
      File.directory?(Rails.root.join('public', 'uploads','es'))
      specific_path = Rails.root.join('public', 'uploads','es', now+ext)
  
      # Save the file to the specific path
      File.open(specific_path, 'wb') do |f|
        f.write(file.read)
      end
      require 'mini_magick'
      # Path to the input PDF file
      pdf_path = specific_path

      # Path to save the output image file
      output_image_path = Rails.root.join('public', 'uploads','es', now+'.png')
      # Use MiniMagick to convert the first page of the PDF to an image
      image = MiniMagick::Image.open(pdf_path)
      image.format('png')
      image.page('1')
      image.resize('800x') # Resize the image if needed
      image.write(output_image_path)
      return specific_path.to_s.split("public/")[1]
    end
end
