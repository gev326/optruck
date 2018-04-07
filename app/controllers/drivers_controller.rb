class DriversController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!
  before_action :set_driver,  only: [:show, :edit, :update, :destroy ]

  # GET /drivers
  # GET /drivers.json
  def index
    @q = Driver.ransack(params[:q])
    @drivers = @q.result(distinct: true)
    @located_drivers = get_located_drivers @drivers
    @hash = generate_hash_map @located_drivers

  end

  # def home_feed
  #   @drivers = Driver.ransack(params[:q])
  #   render :partial => "/drivers"
  # end

  def state_drivers
    new_params = {
      :state_lat => params[:state_lat],
      :state_lng => params[:state_lng]
    }
    redirect_to show_state_drivers_path new_params
  end

  def show_state_drivers
    result = Geocoder.search([ params[:state_lat], params[:state_lng] ])
    if !result[0]
      @drivers = []
      @located_drivers = []
      @hash = generate_hash_map []
      @state = 'Unknown Region'
      return
    end
    @state = result[0].state
    @drivers = get_click_point_drivers @state
    @located_drivers = get_located_drivers @drivers
    @hash = generate_hash_map @located_drivers
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

  def generate_hash_map located_drivers
    Gmaps4rails.build_markers(located_drivers) do |driver, marker|
      driver_path = view_context.link_to driver.full_name, driver_path(driver)
      driver_id_tag = driver.driver_id_tag
      driver_desired = driver.desired_state
      driver_phone = driver[:driver_phone]
      truck_type = driver[:driver_truck_type]
      available = driver.driver_availability.strftime("%m/%d/%Y")
      comments = driver[:comments]
      marker.lat driver.latitude
      marker.lng driver.longitude
      marker.title driver.full_name
      marker.json(:id => driver[:id])
      marker.infowindow (
        %Q(
          Driver: #{driver_path}<br><br>
          Driver ID: #{driver_id_tag}<br><br>
          Phone: #{driver_phone}<br><br>
          Desired State: #{driver_desired}<br><br>
          Truck Type: #{truck_type}<br><br>
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
    if params[:report]
      @search = params[:search]
      @report = Driver.find(params[:report])
      @next_idx = get_next_report_idx params[:report], @driver.id
      @previous_idx = get_previous_report_idx params[:report], @driver.id
    end
  end

  def get_next_report_idx report, id
    last_index = report.length - 1
    report.index("#{id}") + 1 <= last_index ?
      report.index("#{id}") + 1 : 0
  end

   def get_previous_report_idx report, id
    last_index = report.length + 1
    report.index("#{id}") - 1 <= last_index ?
      report.index("#{id}") - 1 : 0
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
    params[:driver][:first_name].strip!
    params[:driver][:last_name].strip!

    desired_state = params[:driver][:desired_state]
    desired_city = params[:driver][:desired_city]
    if desired_state && desired_state.length != 0
      state_abbrv = get_state_abbrev desired_state
      zone = get_destination_zone state_abbrv
      params[:driver][:destination_zone] = zone
    elsif desired_city && desired_city.length != 0
      result = Geocoder.search(desired_city)
      if result[0]
        state_abbrv = get_state_abbrev result[0].state
        zone = get_destination_zone state_abbrv
        params[:driver][:desired_state] = result[0].state
        params[:driver][:destination_zone] = zone
      end
    else
      params[:driver][:destination_zone] = nil
    end

    current_state = params[:driver][:current_state]
    current_city = params[:driver][:current_city]
    if current_state && current_state.length != 0
      params[:driver][:backhaul] = current_state == 'California' ? false : true
    elsif current_city && current_city.length != 0
      loc = Geocoder.search(current_city, :params => {:countrycodes => 'us'})
      if loc.length != 0
        params[:driver][:backhaul] = loc[0].state == 'California' ? false : true
      end
    elsif current_state.length == 0 && current_city.length == 0
      params[:driver][:backhaul] = true
    end

     if current_state && current_state.length != 0
      state_abbrv = get_state_abbrev current_state
      current_zone = get_current_zone state_abbrv
      params[:driver][:current_zone] = current_zone
    elsif current_city && current_city.length != 0
      result = Geocoder.search(current_city)
      if result[0]
        state_abbrv = get_state_abbrev result[0].state
        zone = get_current_zone state_abbrv
        params[:driver][:current_state] = result[0].state
        params[:driver][:current_zone] = zone
      end
    else
      params[:driver][:current_zone] = nil
    end

    @driver = Driver.new(driver_params)

    respond_to do |format|
      if @driver.save
        marker = nil
        if @driver.current_state.length != 0 || @driver.current_city.length != 0
          marker = generate_hash_map [@driver]
        end
        ActionCable.server.broadcast(
          'driver_channel',
          {
            :msg=>'add-driver',
            :driver=>@driver,
            :marker=>marker
          }
        )
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
    params[:driver][:first_name].strip!
    params[:driver][:last_name].strip!

    covered_name = nil
    if params[:driver][:Covered] == '1'
      params[:driver][:user_id] = current_user.id
      covered_name = current_user.full_name
    else
      params[:driver][:user_id] = nil
    end

    desired_state = params[:driver][:desired_state]
    desired_city = params[:driver][:desired_city]
    if desired_state && desired_state.length != 0
      state_abbrv = get_state_abbrev desired_state
      zone = get_destination_zone state_abbrv
      params[:driver][:destination_zone] = zone
    elsif desired_city && desired_city.length != 0
      result = Geocoder.search(desired_city)
      if result[0]
        state_abbrv = get_state_abbrev result[0].state
        zone = get_destination_zone state_abbrv
        params[:driver][:desired_state] = result[0].state
        params[:driver][:destination_zone] = zone
      end
    else
      params[:driver][:destination_zone] = nil
    end

    current_state = params[:driver][:current_state]
    current_city = params[:driver][:current_city]
    if current_state && current_state.length != 0
      params[:driver][:backhaul] = current_state == 'California' ? false : true
    elsif current_city && current_city.length != 0
      loc = Geocoder.search(current_city, :params => {:countrycodes => 'us'})
      if loc.length != 0
        params[:driver][:backhaul] = loc[0].state == 'California' ? false : true
      end
    elsif current_state.length == 0 && current_city.length == 0
      params[:driver][:backhaul] = true
    end

       if current_state && current_state.length != 0
      state_abbrv = get_state_abbrev current_state
      current_zone = get_current_zone state_abbrv
      params[:driver][:current_zone] = current_zone
    elsif current_city && current_city.length != 0
      result = Geocoder.search(current_city)
      if result[0]
        state_abbrv = get_state_abbrev result[0].state
        zone = get_current_zone state_abbrv
        params[:driver][:current_state] = result[0].state
        params[:driver][:current_zone] = zone
      end
    else
      params[:driver][:current_zone] = nil
    end

    respond_to do |format|
      if @driver.update(driver_params)
        marker = nil
        if @driver.current_state.length != 0 || @driver.current_city.length != 0
          marker = generate_hash_map [@driver]
        end
        ActionCable.server.broadcast(
          'driver_channel',
          {
            :msg=>'update-driver',
            :driver=>@driver,
            :covered_name=>covered_name,
            :marker=>marker
          }
        )
        report = nil
        search = nil
        if params[:report]
          report = JSON.parse(params[:report])
          search = JSON.parse(params[:search])
        end
        format.html {
          redirect_to driver_path(
            id: @driver.id,
            report: report,
            search: search
          ),
          notice: 'Driver was successfully updated.'
        }
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
    ActionCable.server.broadcast(
      'driver_channel',
      {:msg=>'delete-driver', :id=>@driver.id}
    )
    respond_to do |format|
      format.html { redirect_to drivers_url, notice: 'Driver was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  # search
  def reports
    radius = params[:miles] && params[:miles].length != 0
    start_date = nil
    end_date = nil
    address = nil
    lat_lon = nil
    radius_drivers = nil
    range_drivers = nil
    saved_range = nil
    saved_state = nil
    saved_city = nil
    q = params[:q]

    if q
      q[:Etrac_eq] = nil if q[:Etrac_eq] == '0'
      q[:PlateTrailer_eq] = nil if q[:PlateTrailer_eq] == '0'
      q[:backhaul_eq] = nil if q[:backhaul_eq] == '0'

      if q[:driver_availability_in].length != 0
        saved_range = q[:driver_availability_in]
        parts = q[:driver_availability_in].split(' - ')
        q[:driver_availability_in] = nil
        start_parts = parts[0].split('/')
        end_parts = parts[1].split('/')
        start_year = start_parts[2].to_i
        start_mo = start_parts[0].to_i
        start_day = start_parts[1].to_i
        end_year = end_parts[2].to_i
        end_mo = end_parts[0].to_i
        end_day = end_parts[1].to_i
        start_date = Date.new(start_year, start_mo, start_day)
        end_date = Date.new(end_year, end_mo, end_day)
        range_drivers = Driver.where(
          "driver_availability >= :start_date AND " +
          "driver_availability <= :end_date",
          {start_date: start_date, end_date: end_date}
        )
      end
    end

    state = q && q[:current_state_eq] && q[:current_state_eq].length != 0
    city = q && q[:current_city_cont] && q[:current_city_cont].length != 0
    if radius && (state || city)
      radius = params[:miles].to_f
      # use state if city not present otherwise always
      # use city for radius searches.
      if state && !city
        address = q[:current_state_eq]
      else
        address = q[:current_city_cont]
      end
      lat_lon = Geocoder.coordinates(address)
      # since we are fuzzy matching we may not get a latlng
      # this allows the user to put in garabage without breaking
      # the form
      if lat_lon
        saved_state = q[:current_state_eq]
        saved_city = q[:current_city_cont]
        q[:current_state_eq] = nil
        q[:current_city_cont] = nil
      end
    end

    drivers = nil
    if range_drivers && lat_lon && address && radius
      drivers = range_drivers.near(address, radius)
    elsif range_drivers
      drivers = range_drivers
    elsif address && lat_lon && radius
      drivers = Driver.near(address, radius)
    else
      drivers = Driver.all
    end

    @q = drivers.ransack(params[:q])
    if saved_state && saved_city
      q[:current_state_eq] = saved_state
      q[:current_city_cont] = saved_city
    end
    if saved_range
      q[:driver_availability_in] = saved_range
    end
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
      :current_location,
      :desired_state,
      :driver_id_tag,
      :driver_phone,
      :driver_truck_type,
      :active,
      :driver_status,
      :driver_availability,
      :driver_company,
      :comments,
      :Covered,
      :user_id,
      :Etrac,
      :PlateTrailer,
      :insurance,
      :state_lat,
      :state_lng,
      :destination_zone,
      :current_zone,
      :contact_name,
      :backhaul,
      :PreferredLanes => []
    )
  end
end
