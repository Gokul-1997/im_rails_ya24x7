module Api
  module V1
class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :update, :destroy]
#  skip_before_action :authenticate_request, only: %i[login register]

  # GET /sessions
  def index
    @sessions = Session.all
 
    render json: @sessions
  end

  # GET /sessions/1
  def show
    render json: @session
  end

  # POST /sessions
 
  def login
    authenticate params[:email_id], params[:password]
  end

  def test
    render json: {key: "ok"}
    #authenticate params[:email_id], params[:password]
  end



  def create      
    user = User.authenticate(params)
     if user == true
      render json: {"first_name":"Altius","usertype_id":"2"}
    elsif user && user.usertype_id == 1
      
      if user.tenant.setting.ct == true
        ct = true
      else
        ct = false
      end

      if params[:player_id].present?
        player_id = params[:player_id]
        unless OneSignal.find_by_player_id(params[:player_id]).present?
          onesignal = OneSignal.create(user_id:user.id,tenant_id: user.tenant.id,player_id:player_id)        
        end
      end

      
      render json: {
          message: "User Login Succsussfully",
          type: user.usertype_id,
          user: user,
          id: user.id,
          first_name: user.first_name,
          usertype_id: user.usertype_id,
          tenant_id: user.tenant_id,
          role_id: user.role_id,
          player_id: user.phone_number,
          onesignal_id: user.last_name,
          machine_count: user.tenant.machines.count,
          setting: user.tenant.setting
        }
    elsif user && user.usertype_id == 2
      render json: {
          message: "Admin Login Succsussfully",
          first_name: user.first_name,
          usertype_id: user.usertype_id
      }
   else
      render json: false
   
    end




=begin
    if user  && user != true
      render json: {"id":user.id,"first_name":user.first_name,"usertype_id":user.usertype_id,"tenant_id":user.tenant_id,"role_id":user.role_id,"player_id":user.phone_number,"onesignal_id":user.last_name,"machine_count":user.tenant.machines.count}
    elsif user == true
      render json: {"first_name":"Altius","usertype_id":"2"}
    else
      render json: false
    end
=end

  end

  # PATCH/PUT /sessions/1
  def update
    if @session.update(session_params)
      render json: @session
    else
      render json: @session.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sessions/1
  def destroy
    @session.destroy
    #@session.update(isactive:0)
  end

  def change_pwd
    user = User.changepwd(params)
    if user
      render json: user
    else
      render json: false
    end
  end

  def forgot_pwd
  user = User.forgot_password(params)
  if user
      render json: user
    else
      render json: false
    end
  end

  def change_pwd_web
    user = User.changepwd_web(params)
    if user
      render json: user
    else
      render json: false
    end
  end
   
   def api
    return true
   end
    def alarm
    return true
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session
      @session = Session.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def session_params
      params.fetch(:session, {})
    end

  def authenticate(email, password)
    command = AuthenticateUser.call(email, password)  
    if command.success?
      user_id = JsonWebToken.decode(command.result)["user_id"]
      user = User.find(user_id)
      
      if user.usertype_id == 1
      render json: {
          type: user.usertype_id,
          user: user,
          id: user.id,
          first_name: user.first_name,
          usertype_id: user.usertype_id,
          tenant_id: user.tenant_id,
          role_id: user.role_id,
          player_id: user.phone_number,
          onesignal_id: user.last_name,
          machine_count: user.tenant.machines.count,
          setting: user.tenant.setting,
          access_token: command.result,
           message: 'Login Successful'
      }
    else
       render json: {
          type: user.usertype_id,
          user: user,
          id: user.id,
          first_name: user.first_name,
          usertype_id: user.usertype_id,
          tenant_id: user.tenant_id,
          role_id: user.role_id,
          player_id: user.phone_number,
          onesignal_id: user.last_name,
         # machine_count: user.tenant.machines.count,
          #setting: user.tenant.setting,
          access_token: command.result,
           message: 'Login Successful'
      }
    end
    else
      render json: { error: command.errors }, status: :unauthorized
    end
   end


end
end
end
