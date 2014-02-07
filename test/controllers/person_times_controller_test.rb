require 'test_helper'

class PersonTimesControllerTest < ActionController::TestCase
  setup do
    @person_time = person_times(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:person_times)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create person_time" do
    assert_difference('PersonTime.count') do
      post :create, person_time: {  }
    end

    assert_redirected_to person_time_path(assigns(:person_time))
  end

  test "should show person_time" do
    get :show, id: @person_time
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @person_time
    assert_response :success
  end

  test "should update person_time" do
    patch :update, id: @person_time, person_time: {  }
    assert_redirected_to person_time_path(assigns(:person_time))
  end

  test "should destroy person_time" do
    assert_difference('PersonTime.count', -1) do
      delete :destroy, id: @person_time
    end

    assert_redirected_to person_times_path
  end
end
