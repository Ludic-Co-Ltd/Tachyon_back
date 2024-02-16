class UserController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ] 
  before_action :authenticate_request!, only:%i[ apply_mentor myinfo update_myinfo]
  before_action :admin_request!, only:%i[index create]

  def register
    begin
      if params[:password] != params[:password_confirm]
        render json:{ error: 'パスワードが一致しません。'}, status: 401
      else
      @user=User.find_by(email:params[:email])
      if @user
        render json:{ error: 'ユーザーはすでに存在しています。'}, status: 401
      else 
          @user=User.new({
            mentor_id:params[:mentor_id],
            # plan_id:1,
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
            industry_id_1:params[:industry_id_1],
            industry_id_2:params[:industry_id_2],
            status:1,
          })
          if @user.save
            render json: payload(@user), status: 200
          else
            puts @user.errors.messages
            render json:  {error: '入力情報が正しくありません。'}, status: 422
          end
        end
      end
    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  def login
    begin 
      @user = User.find_by(email: params[:email]).try(:authenticate, params[:password])
      
      if @user
        # render json: {status: 200, data: payload(@user)}
        render json:  payload(@user), status: 200
      else
        render json:  {error: 'メールやパスワードが正しくありません。'}, status: 401
      end
    rescue => error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  def refresh_token
    begin 
      if request.cookies?.jwt
        refresh_token = request.cookies.jwt
        if JsonWebToken.decode(refresh_token) && JsonWebToken.decode(refresh_token).user_id
          puts JsonWebToken.decode(refresh_token)
        else
          render json: { status: 406, error: '認証エラー'}
        end
      else
        render json: {status: 406, error: '認証エラー'}
      end
    rescue => error
      render json: { error: 'サーバーエラー。'}, status: 500
    end
  end

  # GET /users
  def index
    begin
      @users = User.all  
      users=[]
      for u in @users
        user = {}
        user[:id] = u.id
        user[:user_name] = u.full_name
        user[:mentor] = u.mentor.full_name
        user[:interview_ticket_number] = u.user_tickets.where.not(status: 1).sum(:interview_ticket_number)
        user[:event_ticket_number] = u.user_tickets.where.not(status: 1).sum(:event_ticket_number)
        user[:es_ticket_number] = u.user_tickets.where.not(status: 1).sum(:es_ticket_number)
        user[:case_ticket_number] = u.user_tickets.where.not(status: 1).sum(:case_ticket_number)
        users.push(user)
      end
      render json: users, status: 200
      # render json: @users.to_json(
      #   include: [
      #     :user_tickets => {
      #       only: [:es_ticket_number, :case_ticket_number, :event_ticket_number, :interview_ticket_number],
      #       # include: { user_tickets: {
      #         methods: ->(user_ticket) { user_ticket.allowed_user_tickets }
      #       # }}
      #     },
      #     :mentor => {only: [:user_name]}
      #   ],
      #   except: [
      #     :email,
      #     :password_digest,
      #     :birth_date,
      #     :gender,
      #     :status,
      #     :created_at,
      #     :updated_at,
      #     :deleted_at
      #   ]
      # ), status: 200
    rescue => error
      puts error
      render json: { error: 'サーバーエラー。'}, status: 500
    end
  end

  def apply_mentor
    begin
      @user = User.find(current_user.id)
      
      if @user
        @user.mentor_id = params[:mentor_id]
        @user.save
        render json: 'success', status: 200
      else
        render json: { error: 'リソースが存在しません'}, status: 404
      end
    rescue => error
      render json: { error: 'サーバーエラー。'}, status: 500
    end
  end

  # GET /users/1
  def myinfo
    begin
      if current_user
        industry_1= Industry.find(current_user.industry_id_1).name
        industry_2= Industry.find(current_user.industry_id_2).name
        render json: {user:current_user.to_json(
          include: [
            :user_tickets,
            :mentor => {only: [:user_name]},
          ],
          except: [:created_at, :updated_at, :deleted_at]
          ), industry1:industry_1, industry2:industry_2}, status:200
      else
        render json: { error: 'リソースが存在しません'}, status: 404
      end
    rescue => error
      puts error
      render json: { error: 'サーバーエラー。'}, status: 500
    end
  end

  def show
    begin
      if @user
        render json: @user.to_json(
          include: [
            :user_tickets,
            :mentor => {only: [:user_name]},
          ],
          except: [:created_at, :updated_at, :deleted_at]
          ), status:200
      else
        render json: { error: 'リソースが存在しません'}, status: 404
      end
    rescue => error
      render json: { error: 'サーバーエラー。'}, status: 500
    end
  end

  # POST /users
  def create
    begin
      if params[:password] != params[:confirm_password] || params[:password].length<8
        render json:{ error: 'パスワードが一致しません。'}, status: 401
      else
      @user=User.find_by(email:params[:email])
      if @user
        render json:{ error: 'ユーザーはすでに存在しています。'}, status: 401
      else 
          @user=User.new({
            mentor_id:params[:mentor_id],
            # plan_id:1,
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
            industry_id_1:params[:industry_id_1],
            industry_id_2:params[:industry_id_2],
            status:1,
          })
          if @user.save
            render json: @user, status: 200
          else
            puts @user.errors.messages
            render json:  {error: '入力情報が正しくありません。'}, status: 422
          end
        end
      end
    rescue => error
      puts error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  # PATCH/PUT /users/1
  def update
    # user = params.require(:user).permit!
    # if user[:password] != user[:confirm_password] || user[:password].length<8
    #   render json:{ error: 'パスワードが一致しません。'}, status: 401
    # else
      if @user.update(params.require(:user).permit!)
        render json: @user
      else
        render json: @user.errors, status: 422
      end
  end

  def update_myinfo
    if params[:password] && params[:password] != params[:password_confirm]
      render json:{ error: 'パスワードが一致しません。'}, status: 401
    elsif params[:password]
      current_user.password =  params[:password]
    end
    current_user.first_name = params[:first_name]
    current_user.last_name = params[:last_name]
    current_user.email = params[:email]
    current_user.birth_date = params[:birth_date]
    current_user.gender = params[:gender]
    current_user.university = params[:university]
    current_user.faculty = params[:faculty]
    current_user.department = params[:department]
    current_user.graduation_year = params[:graduation_year]
    current_user.industry_id_1 = params[:industry_id_1]
    current_user.industry_id_2 = params[:industry_id_2]
    current_user.mentor_id = params[:mentor_id]
    if current_user.save
      render json: current_user
    else
      render json: current_user.errors.messages, status: 422
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
    render json: @user, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.includes(:mentor).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:email, :password)
      # params.require(:user).permit!
    end

    def payload(user)
      return nil unless user and user.id
      {
        auth_token: JsonWebToken.encode(
          {
            id: user.id, 
            email:user.email,
            exp:24.hours.from_now.to_i
          }
        ),
        expire_in: 24*3600,
        user: user.as_json(except: [:password_digest, :created_at, :updated_at, :deleted_at])
      }
    end

    def refresh(user)
      return nil unless user and user.id
      {
        refresh_token:JsonWebToken.encode({
          user_email:user.email,
          user_id: user.id, 
          exp:24.hours.from_now.to_i
        })
      }
    end
end
