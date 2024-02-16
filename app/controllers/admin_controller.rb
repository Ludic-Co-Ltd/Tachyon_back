class AdminController < ApplicationController
  before_action :set_admin, only: %i[ show update destroy ] 

  def register
    if admin_params[:password] != admin_params[:password_confirm]
      render json:{error: 'パスワードが一致しません。', status:401}
    else
      @admin=Admin.find_by(email:admin_params[:email])
      if @admin
        render json:{error: 'ユーザーはすでに存在しています。', status:401}
      else 
        @admin=Admin.new(admin_params)
        if @admin.save
          render json: payload(@admin), status:200
        else
          render json: {errors: @admin.errors}, status: 422
        end
      end
    end
  end

  def login
    begin 
      @admin = Admin.find_by(email: params[:email]).try(:authenticate, params[:password])
      
      if @admin
        # render json: {status: 200, data: payload(@user)}
        render json:  payload(@admin), status: 200
      else
        render json:  {error: 'メールやパスワードが正しくありません。'}, status: 401
      end
    rescue => error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end
  # GET /admins
  def index
    @admins = Admin.all

    render json: @admins
  end

  # GET /admins/1
  def show
    render json: @admin
  end

  # POST /admins
  def create
    @admin = Admin.new(admin_params)

    if @admin.save
      render json: @admin, status: 200, location: @admin
    else
      render json: @admin.errors, status: 422
    end
  end

  # PATCH/PUT /admins/1
  def update
    if @admin.update(admin_params)
      render json: @admin
    else
      render json: @admin.errors, status: 422
    end
  end

  # DELETE /admins/1
  def destroy
    @admin.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_params
      # params.fetch(:admin, {})
      params.require(:admin).permit!
    end

    def payload(admin)
      return nil unless admin and admin.id
      {
        admin_token: JsonWebToken.encode(
          {
            id: admin.id, 
            email:admin.email,
            exp:24.hours.from_now.to_i
          }
        ),
        expire_in: 24*3600,
        admin: admin.as_json(except: [:password_digest, :created_at, :updated_at, :deleted_at])
      }
    end
end
