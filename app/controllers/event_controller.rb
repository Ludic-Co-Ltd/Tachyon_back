class EventController < ApplicationController
  before_action :set_event, only: %i[ show update destroy ] 
  before_action :authenticate_request!, only: %i[ reservable events_calandar week_events] 
  before_action :admin!, only: %i[ delete] 

  # GET /events
  def index
    begin
      first_day = Date.parse(params[:week])
      events = week_events(first_day)

      render json: events, status:200

    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end
  
  def events_calandar
    
    begin
    #   {
    #   title: 'Meeting with Team',
    #   start: '2024-01-17T10:20:00',
    #   end: '2024-01-17T12:00:00',
    #   color: 'red'
    # },
    @my_reservations = EventReservation.select(:user_id, :event_id).where(user_id: current_user.id)
    ids=[]
    for mr in @my_reservations
      ids.push(mr.event_id)
    end
    @events = Event.where(event_date: params[:startDate]..params[:endDate])
                      # .where(id: ids) 
                      .where(deleted_at: nil)
                      .order(event_date: :asc)
      
    events = []
    
    for event in @events
      if ids.include?(event.id) && event.event_type == 1
        color="#3081D0"
      elsif ids.include?(event.id) && event.event_type == 2
        color="#BB2525"
      elsif !ids.include?(event.id) && event.event_type == 1
        color="#6DB9EF"
      elsif !ids.include?(event.id) && event.event_type == 2
        color="#fd8e8e"
      end
      events.push({
        id:event.id,
        title:event.name,
        type: event.event_type,
        state: ids.include?(event.id),
        date: event.event_date.to_s,
        start: event.start_time,
        end: event.end_time,
        color: color,
        # name:event.name,
        image_path:event.image_path,
        event_date:event.event_date,
        # start_time:event.start_time,
        # end_time:event.end_time,
        zoom_url:event.zoom_url,
        open_chat_url:event.open_chat_url,
        rating:event.rating,
      })
    end

    @interviews = InterviewReservation.includes(:mentor)
                      .where(user_id: current_user.id)
                      .where(interview_date: params[:startDate]..params[:endDate])
                      .where(deleted_at: nil)
                      .order(interview_date: :asc)
    
    for interview in @interviews

      events.push({
        id:interview.id,
        title:interview.mentor.last_name + ' ' + interview.mentor.first_name,
        type: 3,
        state: 0,
        date: interview.interview_date.to_s,
        start: interview.interview_date.to_s,
        end: (interview.interview_date + 60*60 ).to_s,
        color: '#f7c92a',
        event_date:interview.interview_date,
        zoom_url:interview.mentor.zoom_url,
        open_chat_url:interview.mentor.line_url,
      })
    end
    render json: events, status: 200
    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  def events3
    begin
  
      @events = Event.select(:id, :image_path, :name, :event_date, :rating).order(event_date: :asc).limit(2)

      render json: @events, status:200

    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  def myevents
    begin      
      # Date.today
      print ">>>>>>>>>>>>>>>>>>" + Date.today.strftime("%Y-%m-%d")
      @events = Event.includes(:company).where(deleted_at: nil).where("event_date > ?", Date.today.strftime("%Y-%m-%d")).order(event_date: :desc)
      render json: @events.to_json(include: [:company=>{only: [:id, :name]}]), status:200

    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end

  end

  def gelillas
    begin
      
      @events = Event.select(:id, :image_path, :name, :event_date, :rating, :end_time, :start_time)
                      .where(event_type: 2).order(event_date: :asc)      

      render json: @events, status:200

    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  def reservable
    begin
      today = Date.today
      ten_days_later = today + 20.days
      @event_reservations = EventReservation.select(:user_id, :event_id).where(user_id: current_user.id)
      ids=[]
      for er in @event_reservations
        ids.push(er.event_id)
      end
      @events = Event.select(:id, :image_path, :name, :event_date, :rating, :company_id, :deleted_at)
                .includes(:company)
                .where(event_date: today..ten_days_later)
                .where(deleted_at: nil)
                .where.not(id: ids)
                .order(event_date: :desc)
                .limit(10)

      render json: @events.to_json(include: [:company=>{only: [:id, :name]}]), status:200

    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  # GET /events/1
  def show
    begin
      @event = Event.find(params[:id])
      if @event
        render json: @event.to_json(
          include: [:company=>{only: [:name, :logo_path]}],
          except: [ :created_at, :updated_at, :deleted_at]
          ), status:200
      else
        render json: {error: 'リソースが存在しません', status: 404}
      end
    rescue => error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  # POST /events
  def create
    begin
      image_file = params[:image]
      material_file = params[:material]
      image_path = upload_file(image_file, 'event')
      materials_path = upload_file(material_file, 'material')
      puts params[:company_id]
      @event = Event.new({
        company_id: params[:company_id],
        mentor_id: params[:mentor_id],
        name: params[:name],
        overview: params[:overview],
        image_path: image_path,
        materials_path: materials_path,
        rating: params[:rating],
        event_date:params[:event_date],
        start_time:params[:start_time],
        end_time:params[:end_time],
        event_type:params[:event_type],
        open_chat_url:params[:open_chat_url],
        zoom_url:params[:zoom_url],
      })

      if @event.save
        render json: @event, status: 200
      else
        puts @event.errors.messages
        render json: @event.errors, status: 422
      end
    rescue =>error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  # PATCH/PUT /events/1
  def update
    begin
      image_file = params[:image]
      material_file = params[:material]
      image_path = image_file ? upload_file(image_file, 'event') : params[:image_path]
      materials_path = material_file ? upload_file(material_file, 'material') : params[:materials_path]
     
      @event.company_id = params[:company_id]
      @event.mentor_id = params[:mentor_id]
      @event.name = params[:name]
      @event.overview = params[:overview]
      @event.image_path = image_path
      @event.materials_path = materials_path
      @event.rating = params[:rating]
      @event.event_date = params[:event_date]
      @event.start_time = params[:start_time]
      @event.end_time = params[:end_time]
      @event.event_type = params[:event_type]
      @event.open_chat_url = params[:open_chat_url]
      @event.zoom_url = params[:zoom_url]
      
      if @event.save
        render json: @event, status: 200
      else
        puts @event.errors.messages
        render json: @event.errors, status: 422
      end
    rescue =>error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  # DELETE /events/1
  def destroy
    @event.deleted_at = Time.now
    @event.save
    render json: @event, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      # params.fetch(:user, {})
      params.require(:event).permit!
    end

    def upload_file(file, category)
      # Define the specific path where you want to save the file
      ext = File.extname(file.original_filename)
      now=Time.now.strftime("%Y%m%d_%H%M%S")
      FileUtils.mkdir_p(Rails.root.join('public', 'uploads','events')) unless
      File.directory?(Rails.root.join('public', 'uploads','events'))
      specific_path = Rails.root.join('public', 'uploads','events', category+'_'+now+ext)
      # Save the file to the specific path
      File.open(specific_path, 'wb') do |f|
        f.write(file.read)
      end
      return specific_path.to_s.split("public/")[1]
    end

    def week_events(first_day)

      # @my_reservations = EventReservation.where(user_id: current_user.id)
      # ids=[]
      # for mr in @my_reservations
      #   ids.push(mr.event_id)
      # end

      after_week = first_day + 7.days
      @events = Event.select(:id, :image_path, :name, :event_date, :rating, :start_time, :end_time, :event_type, :deleted_at)
                      .where(event_date: first_day..after_week)
                      .where(deleted_at: nil)
                      .order(event_date: :asc)
      
      events = Hash.new([])
      for event in @events
        weekday_number = event.event_date.wday
        weekday = Date::DAYNAMES[weekday_number]
        events[weekday] = events[weekday] + [event]
      end

      return events
  
    end
end
