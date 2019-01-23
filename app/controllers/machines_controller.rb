class MachinesController < ApplicationController
  before_action :set_machine, only: [:show, :update, :destroy]

  # GET /machines
  def index
    @machines = Machine.where(tenant_id:params[:tenant_id])

    render json: @machines
  end

  # GET /machines/1
  def show
    render json: @machine
  end

  # POST /machines
  def create
    @machine = Machine.new(machine_params)

    if @machine.save
      render json: @machine, status: :created, location: @machine
    else
      render json: @machine.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /machines/1
  def update
    if @machine.update(machine_params)
      render json: @machine
    else
      render json: @machine.errors, status: :unprocessable_entity
    end
  end

  # DELETE /machines/1
  def destroy
    @machine.destroy? ? true : false
  end

  def machinelog_entry
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_machine
      @machine = Machine.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def machine_params
      params.require(:machine).permit(:machine_name, :machine_model, :machine_serial_no, :machine_type, :tenant_id)
    end
end
