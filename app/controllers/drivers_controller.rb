class DriversController < ApplicationController
  before_action :set_driver, only: [:show, :update, :destroy]
  before_action :authenticate_request, only: [:profile]

  # GET /drivers
  def index
    @users = Driver.all
    render json: @users
  end

  # GET /driver/:id
  def show
    render json: @driver
  end

  def profile
    render json: @current_user
  end

  # POST /drivers
  def create
    @driver = Driver.new(driver_params)

    if @driver.save
      render json: @driver, status: :created, location: @driver
    else
      render json: @driver.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /drivers/:id
  def update
    if @driver.update(driver_params)
      render json: @driver
    else
      render json: @driver.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    @driver.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_driver
      @driver = Driver.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def driver_params
      params.require(:driver).permit(:username, :password, :email, :phone, :vehicle_details)
    end  
end
