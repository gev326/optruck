require 'test_helper'

class DriversControllerTest < ActionController::TestCase
  setup do
    @driver = drivers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:drivers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create driver" do
    assert_difference('Driver.count') do
      post :create, driver: { active: @driver.active, active: @driver.active, address: @driver.address, comments: @driver.comments, desired_city: @driver.desired_city, desired_state: @driver.desired_state, desired_zip: @driver.desired_zip, driver_availability: @driver.driver_availability, driver_company: @driver.driver_company, driver_contract_number: @driver.driver_contract_number, driver_id_tag: @driver.driver_id_tag, driver_phone: @driver.driver_phone, driver_status: @driver.driver_status, driver_truck_type: @driver.driver_truck_type, first_name: @driver.first_name, last_name: @driver.last_name, latitude: @driver.latitude, longitude: @driver.longitude }
    end

    assert_redirected_to driver_path(assigns(:driver))
  end

  test "should show driver" do
    get :show, id: @driver
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @driver
    assert_response :success
  end

  test "should update driver" do
    patch :update, id: @driver, driver: { active: @driver.active, active: @driver.active, address: @driver.address, comments: @driver.comments, desired_city: @driver.desired_city, desired_state: @driver.desired_state, desired_zip: @driver.desired_zip, driver_availability: @driver.driver_availability, driver_company: @driver.driver_company, driver_contract_number: @driver.driver_contract_number, driver_id_tag: @driver.driver_id_tag, driver_phone: @driver.driver_phone, driver_status: @driver.driver_status, driver_truck_type: @driver.driver_truck_type, first_name: @driver.first_name, last_name: @driver.last_name, latitude: @driver.latitude, longitude: @driver.longitude }
    assert_redirected_to driver_path(assigns(:driver))
  end

  test "should destroy driver" do
    assert_difference('Driver.count', -1) do
      delete :destroy, id: @driver
    end

    assert_redirected_to drivers_path
  end
end
