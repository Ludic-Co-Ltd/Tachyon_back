class ApplicationController < ActionController::API
  attr_reader :current_user

  protected
  def authenticate_request!
    unless user_id_in_token?
      render json: { error: '認証エラー'}, status: 401
      return
    end
    @current_user = User.find(auth_token[:id])
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { error: '認証エラー'}, status: 401 
  end

  def admin_request!
    unless user_id_in_token?
      render json: { error: '認証エラー'}, status: 401
      return
    end
    @current_admin = Admin.find(auth_token[:id])
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { error: '認証エラー'}, status: 401 
  end

  # def admin_request!
  #   unless user_id_in_token?
  #     render json: { error: '認証エラー'}, status: 401
  #     return
  #   end
  #   @current_user = User.find(auth_token[:id])
  # rescue=>error
  #   puts error
  # end

  private
  def http_token
      @http_token ||= if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
    
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:id].to_i
  end

  def is_admin
    @current_user = User.find(auth_token[:id])
    @number = @current_user.user_number.sub('U', '').to_i
    return @is_admin = @number <= 99
  end
end
