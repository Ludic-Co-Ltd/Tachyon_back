class EventReservationController < ApplicationController
  before_action :set_event_reservation, only: %i[ show update destroy ] 
  before_action :authenticate_request!, only: %i[ create user_reservations] 
  # GET /event_reservations
  def index
    @event_reservations = EventReservation.all

    render json: @event_reservations
  end

  def user_reservations
    begin 
          
      today = Date.today
      ten_days_later = today + 10.days

      @event_reservations = EventReservation.select(:user_id, :event_id).where(user_id: current_user.id)
      ids = []
      for er in @event_reservations
        ids.push(er.event_id)
      end
      @events = Event.includes(:company).where(id: ids).where(event_date: today..ten_days_later ).where("event_date > ?", Date.today.strftime("%Y-%m-%d")).where(deleted_at: nil).order(event_date: :asc)
      
      events = []
      for e in @events
        event = e.attributes
        event[:company] = e.company.name
        event[:industry] = e.company.industry.name
        events.push(event)
      end

      @interviews = InterviewReservation.includes(:mentor)
                      .where(user_id: current_user.id)
                      .where(interview_date: params[:startDate]..params[:endDate])
                      .where("interview_date > ?", Date.today.strftime("%Y-%m-%d"))
                      .where(deleted_at: nil)
                      .order(interview_date: :asc)
    
      for interview in @interviews

        events.push({
          
          company: "ZOOM 面談",
          company_id: '',
          created_at: '',
          deleted_at: '',
          end_time: (interview.interview_date + 60*60 ).to_s,
          event_date: (interview.interview_date + 60*60).to_s,
          event_type: '',
          id: interview.id,
          image_path: "uploads/zoom.jpg",
          industry: '',
          materials_path: "",
          mentor_id: interview.mentor_id,
          name: interview.mentor.last_name + ' ' + interview.mentor.first_name,
          open_chat_url: interview.mentor.line_url,
          rating: '',
          start_time: interview.interview_date.to_s,
          updated_at: '',
          zoom_url: interview.mentor.zoom_url,

          # id:interview.id,
          # name:interview.mentor.last_name + ' ' + interview.mentor.first_name,
          # type: 3,
          # state: 0,
          # date: interview.interview_date.to_s,
          # start: interview.interview_date.to_s,
          # end: interview.interview_date.to_s,
          # color: '#f7c92a',
          # event_date:interview.interview_date,
          # zoom_url:interview.mentor.zoom_url,
          # open_chat_url:interview.mentor.line_url,
        })
      end
      # render json: @events.to_json(include: [:company=>{only: [:id,:name, :industry_id]}]), status: 200
      render json: events, status: 200
    
    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  # GET /event_reservations/1
  def show
    render json: @event_reservation
  end

  # POST /event_reservations
  def create
    @event_reservation = EventReservation.new({
      user_id: current_user.id,
      event_id: params[:event_id],
      status: 3,
      fixed_date: params[:fixed_date]
    })

    @user_ticket = UserTicket.new({
      user_id: current_user.id,
      event_ticket_number: -1,
      case_ticket_number: 0,
      es_ticket_number: 0,
      interview_ticket_number: 0,
      bip_id: params[:event_id],
      status:3
    })
    if @event_reservation.save && @user_ticket.save
      render json: {event_reservation:@event_reservation, user_ticket:@user_ticket}, status: 200
    else
      puts @event_reservation.errors.messages
      puts @user_ticket.errors.messages
      render json: @event_reservation.errors, status: 422
    end
  end

  # PATCH/PUT /event_reservations/1
  def update
    if @event_reservation.update(event_reservation_params)
      render json: @event_reservation
    else
      render json: @event_reservation.errors, status: 422
    end
  end

  # DELETE /event_reservations/1
  def destroy
    @event_reservation.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_reservation
      @event_reservation = EventReservation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_reservation_params
      # params.fetch(:user, {})
      params.require(:event_reservation).permit!
    end
end
