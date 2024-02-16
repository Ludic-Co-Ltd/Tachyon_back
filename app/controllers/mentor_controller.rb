class MentorController < ApplicationController
  before_action :set_mentor, only: %i[ update destroy ] 
  before_action :admin_request!, only: %i[ mentors_event salary_change]

  def register
    if params[:password] != params[:password_confirm]
      render json:{error: 'パスワードが一致しません。'}, status:401
    else
      @mentor=Mentor.find_by(email:params[:email])
      if @mentor
        render json:{error: 'ユーザーはすでに存在しています。'}, status:401
      else 
        @mentor=Mentor.new({
          email:params[:email],
          password:params[:password],
          first_name:params[:first_name],
          last_name:params[:last_name],
          birth_date:params[:birth_date],
          gender:params[:gender],
          university:params[:university],
          faculty:params[:faculty],
          department:params[:department],
          graduation_year:params[:graduation_year],
          job_offer_1:params[:job_offer_1],
          job_offer_2:params[:job_offer_2],
          user_name:params[:user_name],
          line_url:params[:line_url],
          timerex_url:params[:timerex_url],
          timerex_url_short:params[:timerex_url_short],
          self_introduction:params[:self_introduction],
        })
        if @mentor.save
          render json: payload(@mentor), status:200
        else
          render json: {errors: @mentor.errors}, status: 422
        end
      end
    end
  end

  def login
    @mentor = Mentor.find_by(email: mentor_params[:email]).try(:authenticate, mentor_params[:password])
    
    mentor_et = []    
    for mentor in @mentor

    end
    
    if @mentor
      render json: payload(@mentor), status:200
    else
      render json: {error: 'メールやパスワードが正しくありません。'}, status: 401
    end
  end
  # GET /mentors
  def index
    begin 
      # @mentors = Mentor.select(:id, :first_name, :last_name, :lecture_salary)
      @mentors = Mentor.select(Mentor.column_names - ['password_digest', 'created_at', 'updated_at', 'deleted_at'])
      render json: @mentors, status:200
    rescue => error
      render json: { error: '無効なリクエストです。'}, status: 400
    end
  end

  def mentors_event
    begin 
      # @mentors = Mentor.select(:id, :first_name, :last_name, :lecture_salary)
      @mentors = Mentor.includes(:mentor_salaries)
      
      y = Date.today.year.to_s
      if(params[:year] && params[:year] != "")
          y = params[:year]
      end

      m = Date.today.month.to_s
      if(params[:month] && params[:month] != "")
          m = params[:month]
      end

      mentors = []
      for men in @mentors
        mentor = {}
        @salary = MentorSalary.where(mentor_id: men.id, year: y, month: m).first 
        mentor[:id] = men.id
        mentor[:last_name] = men.last_name
        mentor[:first_name] = men.first_name
        mentor[:salary] = @salary ? @salary.salary: 0
        mentor[:salary_id] = @salary ? @salary.id: 0
        # u.user_tickets.where.not(status: 1).sum(:interview_ticket_number)
        @users = User.where(mentor_id: men.id).count
        mentor[:users] = @users

        @interviews = InterviewReservation.where(mentor_id: men.id).where('MONTH(interview_date) = ?', m).where('YEAR(interview_date) = ?', y).count
        mentor[:interview] = @interviews

        @events = Event.where(mentor_id: men.id).where('MONTH(event_date) = ?', m).where('YEAR(event_date) = ?', y).count
        mentor[:events] = @events

        @cases = CaseStudy.where(mentor_id: men.id).where('MONTH(start_date) = ?', m).where('YEAR(start_date) = ?', y).count
        mentor[:cases] = @cases

        mentor[:es] = 0

        mentors.push(mentor)
      end
      
      render json: mentors, status:200
    rescue => error
      puts error
      render json: { error: '無効なリクエストです。'}, status: 400
    end
  end

  # GET /mentors/1
  def show
    begin
      @mentor = Mentor.select(Mentor.column_names - ['password_digest', 'created_at', 'updated_at', 'deleted_at']).find(params[:id])
      if @mentor
        render json: @mentor, status:200
      else
        render json: {error: 'リソースが存在しません'}, status: 404
      end
    rescue => error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  # POST /mentors
  def create
    @mentor = Mentor.new(mentor_params)

    if @mentor.save
      render json: @mentor, status: 200, location: @mentor
    else
      render json: @mentor.errors, status: 422
    end
  end

  # PATCH/PUT /mentors/1
  def update
    if @mentor.update(mentor_params)
      render json: @mentor, status: 200
    else
      render json: @mentor.errors, status: 422
    end
  end

  # DELETE /mentors/1
  def destroy
    @mentor.destroy!
    render json: @mentor, status: 200
  end

  def salary_change
    begin
      mentor = params[:mentor]
      year = params[:year]
      month = params[:month]

      if mentor[:salary_id] == 0
        @mentor_salary = MentorSalary.new({
          mentor_id: mentor[:id],
          salary: mentor[:salary],
          year: year,
          month: month
        })
      
      else 
        @mentor_salary = MentorSalary.find(mentor[:salary_id])
        @mentor_salary.salary = mentor[:salary]
      end
        
      if @mentor_salary.save
        render json: @mentor_salary, status:200
      else
        puts @mentor_salary.errors.messages
        render json: {error: 'リソースが存在しません'}, status: 404
      end
    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mentor
      @mentor = Mentor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mentor_params
      # params.fetch(:mentor, {})
      params.require(:mentor).permit!
    end

    def payload(mentor)
      return nil unless mentor and mentor.id
      {
        auth_token: JsonWebToken.encode(
          {mentor_id: mentor.id, mentor_email:mentor.email}
        ),
        mentor: mentor.as_json(except: :password_digest)
      }
    end
end
