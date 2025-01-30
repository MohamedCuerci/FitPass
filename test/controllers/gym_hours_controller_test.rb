require "test_helper"

class GymHoursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gym_hour = gym_hours(:one)
  end

  test "should get index" do
    get gym_hours_url
    assert_response :success
  end

  test "should get new" do
    get new_gym_hour_url
    assert_response :success
  end

  test "should create gym_hour" do
    assert_difference("GymHour.count") do
      post gym_hours_url, params: { gym_hour: { closing_time: @gym_hour.closing_time, day_of_week: @gym_hour.day_of_week, gym_id: @gym_hour.gym_id, opening_time: @gym_hour.opening_time } }
    end

    assert_redirected_to gym_hour_url(GymHour.last)
  end

  test "should show gym_hour" do
    get gym_hour_url(@gym_hour)
    assert_response :success
  end

  test "should get edit" do
    get edit_gym_hour_url(@gym_hour)
    assert_response :success
  end

  test "should update gym_hour" do
    patch gym_hour_url(@gym_hour), params: { gym_hour: { closing_time: @gym_hour.closing_time, day_of_week: @gym_hour.day_of_week, gym_id: @gym_hour.gym_id, opening_time: @gym_hour.opening_time } }
    assert_redirected_to gym_hour_url(@gym_hour)
  end

  test "should destroy gym_hour" do
    assert_difference("GymHour.count", -1) do
      delete gym_hour_url(@gym_hour)
    end

    assert_redirected_to gym_hours_url
  end
end
