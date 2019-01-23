module Api
  module V1
class UserslogsController < ApplicationController
  before_action :set_userslog, only: [:show, :update, :destroy]

  # GET /userslogs
  def index
    @userslogs = Userslog.all

    render json: @userslogs
  end

  # GET /userslogs/1
  def show
    render json: @userslog
  end

  # POST /userslogs
  def create
    @userslog = Userslog.new(userslog_params)

    if @userslog.save
      render json: @userslog, status: :created, location: @userslog
    else
      render json: @userslog.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /userslogs/1
  def update
    if @userslog.update(userslog_params)
      render json: @userslog
    else
      render json: @userslog.errors, status: :unprocessable_entity
    end
  end

  # DELETE /userslogs/1
  def destroy
    @userslog.destroy
    #@userslog.update(isactive:0)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_userslog
      @userslog = Userslog.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def userslog_params
      params.require(:userslog).permit(:first_name, :last_name, :email_id, :password, :phone_number, :remarks, :usertype_id, :approval_id, :tenant_id, :role_id, :user_id)
    end
end
end
end