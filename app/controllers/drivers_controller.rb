class DriversController < ApplicationController
  before_action :set_driver,  only: [:show, :edit, :update, :destroy ]

  # GET /drivers
  # GET /drivers.json
  def index
    @drivers = Driver.all
    @hash = generate_hash_map
  end

  def get_state_drivers
    redirect_to show_state_drivers_path lat: params[:latLng][0], lng: params[:latLng][1]
  end

  def show_state_drivers
    result = Geocoder.search([params[:lat], params[:lng]])
    @state = result[0].state
    @drivers = get_click_point_drivers @state
    @hash = generate_hash_map
  end

  def get_click_point_drivers state
    drivers = Driver.select do |d|
      d.address == state
    end
  end

  def generate_hash_map
    Gmaps4rails.build_markers(@drivers) do |driver, marker|
      driver_path = view_context.link_to driver.full_name, driver_path(driver)
      driver_desired = driver.desired_state
      marker.lat driver.latitude
      marker.lng driver.longitude
      marker.title driver.full_name
      marker.infowindow "Driver: #{driver_path} <br> Desired City: #{driver_desired}"
      if driver.active == true
        marker.picture({
         :url => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=A|008000|000000",
         :width   => 32,
         :height  => 32
        })
        next
      end
      marker.picture({
       :url => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=N|ff0000|000000",
       :width   => 80,
       :height  => 80
      })
    end
  end





  # GET /drivers/1
  # GET /drivers/1.json
  def show

  end

  # GET /drivers/new
  def new
    @driver = Driver.new
  end

  # GET /drivers/1/edit
  def edit
  end

  # POST /drivers
  # POST /drivers.json
  def create
    @driver = Driver.new(driver_params)

    respond_to do |format|
      if @driver.save
        format.html { redirect_to @driver, notice: 'Driver was successfully created.' }
        format.json { render :show, status: :created, location: @driver }
      else
        format.html { render :new }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drivers/1
  # PATCH/PUT /drivers/1.json
  def update
    respond_to do |format|
      if @driver.update(driver_params)
        format.html { redirect_to @driver, notice: 'Driver was successfully updated.' }
        format.json { render :show, status: :ok, location: @driver }
      else
        format.html { render :edit }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drivers/1
  # DELETE /drivers/1.json
  def destroy
    @driver.destroy
    respond_to do |format|
      format.html { redirect_to drivers_url, notice: 'Driver was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


# search
def reports
  miles = params[:miles] && params[:miles].length != 0
  q = params[:q]
  address = q && q[:address_cont] && q[:address_cont].length != 0
  if miles && address
    radius = params[:miles].to_f
    address = q[:address_cont]
    q[:address_cont] = nil
    lat_lon = Geocoder.coordinates(address)
    @q = Driver.near(address, radius).ransack(q)
    return @drivers = @q.result(distinct: true)
  end
  @q = Driver.ransack(params[:q])
  @drivers = @q.result(distinct: true)
end


#   if params[:miles].present? && (params[:miles].to_i > 0)
#    @search = Driver.near(address,params[:miles]).search(params[:q])
#   ### THIS IS THE MAIN CODE YOU HAD @search = Driver.ransack(params[:q])
# else
#   @search = Driver.ransack(params[:q])
#   @drivers = @search.result

  # @location = params[:search]
  #   @distance = params[:miles]
  #   @drivers = Driver.near(@location, @distance)






# def search
#     @location = params[:search]
#     @distance = params[:miles]
#     @farms = Farm.near(@location, @distance)

#     if @location.empty?
#       gflash notice: "You can't search without a search term; please enter a location and retry!"
#       redirect_to "/"
#     else
#       if @farms.length < 1
#         gflash notice: "Sorry! We couldn't find any farms within #{@distance} miles of #{@location}."
#         redirect_to "/"
#       else
#         search_map(@farms)
#       end
#     end

#   end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_driver
      @driver = Driver.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def driver_params
      params.require(:driver).permit(:search, :reports, :first_name, :last_name, :latitude, :longitude, :address, :desired_city, :state, :full_name, :full_address, :desired_state, :desired_zip, :driver_id_tag, :driver_phone, :driver_truck_type, :active, :driver_status, :driver_contract_number, :driver_availability, :driver_company, :comments, :active, :Covered)
    end
end
