class DriversController < ApplicationController
  before_action :authenticate_user!
  before_action :set_driver,  only: [:show, :edit, :update, :destroy ]

  # GET /drivers
  # GET /drivers.json
  def index
    @drivers = Driver.all
    @located_drivers = get_located_drivers @drivers
    @hash = generate_hash_map
  end

  def state_drivers
    redirect_to show_state_drivers_path params
  end

  def show_state_drivers
    result = Geocoder.search([ params[:lat], params[:lng] ])
    if !result[0]
      @drivers = []
      @located_drivers = []
      @hash = generate_hash_map
      @state = 'Unknown Region'
      return
    end
    @state = result[0].state
    @drivers = get_click_point_drivers @state
    @located_drivers = get_located_drivers @drivers
    @hash = generate_hash_map
  end

  def get_click_point_drivers state
    Driver.select do |d|
      d.current_state == state
    end
  end

  def get_located_drivers drivers
    drivers.select do |driver|
      driver.latitude && driver.longitude
    end
  end

  def generate_hash_map
    Gmaps4rails.build_markers(@located_drivers) do |driver, marker|
      driver_path = view_context.link_to driver.full_name, driver_path(driver)
      driver_desired = driver.desired_state
      driver_phone = driver[:driver_phone]
      truck_type = driver[:driver_truck_type]
      reefer = driver[:reeferunit]
      available = driver[:driver_availability]
      comments = driver[:comments]
      marker.lat driver.latitude
      marker.lng driver.longitude
      marker.title driver.full_name
      marker.infowindow (
        %Q(
          Driver: #{driver_path}<br><br>
          Phone: #{driver_phone}<br><br>
          Desired State: #{driver_desired}<br><br>
          Truck Type: #{truck_type}<br><br>
          Reefer Unit: #{reefer}<br><br>
          Available Date: #{available}<br><br>
          Comments: #{comments}
        )
      )
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

    if params[:driver][:Covered] == '1'
      params[:driver][:user_id] = current_user.id
    end

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

    if params[:driver][:Covered] == '1'
      params[:driver][:user_id] = current_user.id
    end

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
    radius = params[:miles] && params[:miles].length !=0
    q = params[:q]
    state = q && q[:current_state_cont] && q[:current_state_cont].length != 0
    city = q && q[:current_city_cont] && q[:current_city_cont].length != 0
    if radius && (state || city)
      radius = params[:miles].to_f

      # use state if city not present otherwise always
      # use city for radius searches.
      if state && !city
        address = q[:current_state_cont]
      else
        address = q[:current_city_cont]
      end
      lat_lon = Geocoder.coordinates(address)

      # since we are fuzzy matching we may not get a latlng
      # this allows the user to put in garabage without breaking
      # the form
      if lat_lon
        q[:current_state_cont] = nil
        q[:current_city_cont] = nil
        @q = Driver.near(address, radius).ransack(q)
        return @drivers = @q.result(distinct: true)
      else
        @q = Driver.ransack(params[:q])
        @drivers = @q.result(distinct: true)
      end
    end
    @q = Driver.ransack(params[:q])
    @drivers = @q.result(distinct: true)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_driver
    @driver = Driver.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def driver_params
    params.require(:driver).permit(
      :search,
      :reports,
      :first_name,
      :last_name,
      :latitude,
      :longitude,
      :current_city,
      :current_state,
      :desired_city,
      :full_name,
      :full_address,
      :desired_state,
      :desired_zip,
      :driver_id_tag,
      :driver_phone,
      :driver_truck_type,
      :active,
      :driver_status,
      :driver_contract_number,
      :driver_availability,
      :driver_company,
      :comments,
      :Covered,
      :user_id,
      :Etrac,
      :PlateTrailer,
      :insurance,
      :reeferunit
    )
  end
end
