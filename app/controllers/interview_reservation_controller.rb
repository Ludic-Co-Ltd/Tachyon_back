class InterviewReservationController < ApplicationController
  before_action :set_interview_reservation, only: %i[ show update destroy ] 
  before_action :authenticate_request!, only: %i[ create ] 

  # GET /interview_reservations
  def index
    @interview_reservations = InterviewReservation.all

    render json: @interview_reservations
  end

  # GET /interview_reservations/1
  def show
    render json: @interview_reservation
  end

  # POST /interview_reservations
  def create
    begin
      @interview_reservation = InterviewReservation.new({
        user_id: current_user.id,
        mentor_id: params[:mentor_id],
        zoom_url: params[:zoom_url],
        category:1,
        status:1,
        interview_date:params[:interview_date]+' '+ params[:interview_time]
      })

      if @interview_reservation.save 
        @user_ticket = UserTicket.new({
          user_id: current_user.id,
          event_ticket_number:0,
          case_ticket_number: 0,
          es_ticket_number: 0,
          interview_ticket_number: -1,
          bip_id: @interview_reservation.id,
          status:3
        })     
      end

      if @interview_reservation.save && @user_ticket.save
        render json: {interview_reservation:@interview_reservation,user_ticket: @user_ticket}, status: 200
      else
        puts @interview_reservation.errors.messages
        render json: @interview_reservation.errors, status: 422
      end
    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  # PATCH/PUT /interview_reservations/1
  def update
    if @interview_reservation.update(interview_reservation_params)
      render json: @interview_reservation
    else
      render json: @interview_reservation.errors, status: 422
    end
  end

  # DELETE /interview_reservations/1
  def destroy
    @interview_reservation.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interview_reservation
      @interview_reservation = InterviewReservation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def interview_reservation_params
      # params.fetch(:user, {})
      params.require(:interview_reservation).permit!
    end
end
