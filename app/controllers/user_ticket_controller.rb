class UserTicketController < ApplicationController
  before_action :set_user_ticket, only: %i[ show update destroy allow_purchase] 
  before_action :authenticate_request!, only:%i[ my_tickets purchase]

  # GET /user_tickets
  def index
    begin
      # UserTicket.delete_all
      @user_tickets = UserTicket.includes(:user)
      if(params[:mentee] && params[:mentee] != "")
        @user_tickets = @user_tickets.where(user_id: params[:mentee])
      end
      if(params[:year] && params[:year] != "")
        @user_tickets = @user_tickets.where('YEAR(created_at) = ?', params[:year])
      end
      if(params[:month] && params[:month] != "")

        y = Date.today.year.to_s
        if(params[:year] && params[:year] != "")
           y = params[:year]
        end
        
        @user_tickets = @user_tickets.where('MONTH(created_at) = ?', params[:month]).where('YEAR(created_at) = ?', y)

      end
      @user_tickets = @user_tickets.all
      # if()
      #   @user_tickets.where("fff")
      tickets = customize_tickets(@user_tickets)

      mentorDatas = []
      @events = Event.includes(:mentor).where('MONTH(created_at) = ?', params[:month]).where('YEAR(created_at) = ?', y)
      
      for event in @events
        mentorData = {}        
        mentorData[:mentor] = event.mentor.full_name
        mentorData[:type] = "イベント"
        mentorData[:color] = "#3081d0"
        mentorData[:name] = event.name
        mentorData[:cost] = '4500'
        mentorData[:date] = event.event_date
        mentorDatas.push(mentorData)
      end

      @interviews = InterviewReservation.includes(:mentor, :user).where('MONTH(created_at) = ?', params[:month]).where('YEAR(created_at) = ?', y)
      
      for inter in @interviews
        interData = {}        
        interData[:mentor] = inter.mentor.full_name
        interData[:type] = "面談"
        interData[:color] = "#f7c92a"
        interData[:name] = inter.user.full_name + "と面談"
        interData[:cost] = '4500'
        interData[:date] = inter.interview_date.to_s[1..10]
        mentorDatas.push(interData)
      end

      # @ess = EntrySheet.includes(:mentor, :user).where('MONTH(created_at) = ?', params[:month]).where('YEAR(created_at) = ?', y)
      
      # for inter in @interviews
      #   interData = {}        
      #   interData[:mentor] = inter.mentor.full_name
      #   interData[:type] = "ES"
      #   interData[:color] = "#00FF00"
      #   interData[:name] = inter.user.full_name + "と面談"
      #   interData[:date] = inter.interview_date[1..10]
      #   mentorDatas.push(interData)
      # end

      @cases = CaseStudy.includes(:mentor).where('MONTH(created_at) = ?', params[:month]).where('YEAR(created_at) = ?', y)
      
      for cs in @cases
        csData = {}        
        csData[:mentor] = cs.mentor.full_name
        csData[:type] = "ケース"
        csData[:color] = "#bb2525"
        csData[:name] = cs.question
        csData[:cost] = '500'
        csData[:date] = cs.start_date.to_s
        mentorDatas.push(csData)
      end

      render json: {tickets:tickets, mentorDatas:mentorDatas}, status: 200
    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  def my_tickets
    begin
      @tickets = UserTicket.where(user_id: @current_user.id, status: 2..3)

      tickets =  { :interview_ticket_number => 0, :es_ticket_number => 0,:case_ticket_number => 0,:event_ticket_number => 0 }
      for t in @tickets
        tickets[:interview_ticket_number] += t.interview_ticket_number ? t.interview_ticket_number : 0
        tickets[:es_ticket_number] += t.es_ticket_number ? t.es_ticket_number : 0
        tickets[:case_ticket_number] += t.case_ticket_number ? t.case_ticket_number : 0
        tickets[:event_ticket_number] += t.event_ticket_number ? t.event_ticket_number : 0
      end
      render json: tickets, status: 200
    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  # GET /user_tickets/1
  def show
    render json: @user_ticket
  end

  # POST /user_tickets
  def create
    @user_ticket = UserTicket.new(user_ticket_params)

    if @user_ticket.save
      render json: @user_ticket, status: 200, location: @user_ticket
    else
      render json: @user_ticket.errors, status: 422
    end
  end

  def purchase
    begin
      @user_ticket = UserTicket.new(user_ticket_params.merge({user_id: @current_user.id, status: 1}))
      if @user_ticket.save
        render json: @user_ticket, status: 200
      else
        render json: @user_ticket.errors.messages, status: 422
      end
    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end    
  end

  def update_mentee_tickets
    begin
      tickets = params[:tickets]
      @user_ticket = UserTicket.new({
        user_id: params[:id],
        es_ticket_number: tickets[:es_ticket_number] ? tickets[:es_ticket_number].to_i : 0,
        case_ticket_number: tickets[:case_ticket_number]? tickets[:case_ticket_number].to_i : 0,
        event_ticket_number: tickets[:event_ticket_number] ? tickets[:event_ticket_number].to_i : 0,
        interview_ticket_number: tickets[:interview_ticket_number] ? tickets[:interview_ticket_number].to_i : 0,
        status: 2
      })
      if @user_ticket.save
        render json: @user_ticket, status: 200
      else
        render json: @user_ticket.errors.messages, status: 422
      end
    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end    
  end

  def allow_purchase
    begin
      @user_ticket.status = 2
      if @user_ticket.save
        @user_tickets = UserTicket.includes(:user).all

        tickets = customize_tickets(@user_tickets)
        render json: tickets, status: 200
      else
        render json: @user_ticket.errors.messages, status: 422
      end
    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end    
  end

  # PATCH/PUT /user_tickets/1
  def update
    if @user_ticket.update(user_ticket_params)
      render json: @user_ticket
    else
      render json: @user_ticket.errors, status: 422
    end
  end

  # DELETE /user_tickets/1
  def destroy
    @user_ticket.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_ticket
      @user_ticket = UserTicket.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_ticket_params
      # params.fetch(:user, {})
      params.require(:user_ticket).permit!
    end

    def customize_tickets(user_tickets)
      tickets = []
      for ut in user_tickets
        puts ut.bip_id
        if ut.status == 3
          if ut.interview_ticket_number < 0
            @interview_reservation = InterviewReservation.includes(:mentor).select(:mentor_id, :id).find(ut.bip_id)
            used_item = @interview_reservation.mentor.full_name + 'と面談しました。'
            ticket_type = '面談'
            ticket_color = '#f7c92a'
          elsif ut.event_ticket_number < 0
            @event = Event.select(:name, :id).find(ut.bip_id)
            used_item = @event.name + 'イベントにチケットを消費しました。'
            ticket_type = 'イベント'
            ticket_color = '#3081d0'
          elsif ut.es_ticket_number < 0
            @entry_sheet = EntrySheet.includes(:company).select(:company_id, :id).find(ut.bip_id)
            used_item = @entry_sheet.company.name + '会社のES添削にチケットを消費しました。'
            ticket_type = 'ES'
            ticket_color = '#00FF00'
          elsif ut.case_ticket_number < 0
            @case_study = CaseStudy.includes(:company).select(:company_id, :id).find(ut.bip_id)
            used_item = @case_study.company.name + '会社のケース添削にチケットを消費しました。'
            ticket_type = 'ケース'
            ticket_color = '#bb2525'
          end

          ticket = {}
          ticket[:id]= ut.id
          ticket[:user_name]= ut.user.full_name          
          ticket[:used_item]= used_item
          ticket[:ticket_type]= ticket_type
          ticket[:ticket_color]= ticket_color
          ticket[:status]= ut.status
          ticket[:date] = ut.created_at
        else
          ticket = {}
          ticket[:id]= ut.id
          ticket[:status]= ut.id
          ticket[:user_name]= ut.user.full_name
          ticket[:interview_ticket_number]= ut.interview_ticket_number
          ticket[:event_ticket_number]= ut.event_ticket_number
          ticket[:es_ticket_number]= ut.es_ticket_number
          ticket[:case_ticket_number]= ut.case_ticket_number
          ticket[:status]= ut.status
          ticket[:date] = ut.created_at
          ticket[:total_price] = ut.interview_ticket_number*4500+ut.event_ticket_number*4500+ut.es_ticket_number*500+ut.case_ticket_number*500
        end

        tickets.push(ticket)
      end
      return tickets
    end
end
