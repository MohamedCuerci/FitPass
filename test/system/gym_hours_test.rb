require "application_system_test_case"

class GymHoursTest < ApplicationSystemTestCase
  setup do
    @gym_hour = gym_hours(:one)
  end

  test "visiting the index" do
    visit gym_hours_url
    assert_selector "h1", text: "Gym hours"
  end

  test "should create gym hour" do
    visit gym_hours_url
    click_on "New gym hour"

    fill_in "Closing time", with: @gym_hour.closing_time
    fill_in "Day of week", with: @gym_hour.day_of_week
    fill_in "Gym", with: @gym_hour.gym_id
    fill_in "Opening time", with: @gym_hour.opening_time
    click_on "Create Gym hour"

    assert_text "Gym hour was successfully created"
    click_on "Back"
  end

  test "should update Gym hour" do
    visit gym_hour_url(@gym_hour)
    click_on "Edit this gym hour", match: :first

    fill_in "Closing time", with: @gym_hour.closing_time.to_s
    fill_in "Day of week", with: @gym_hour.day_of_week
    fill_in "Gym", with: @gym_hour.gym_id
    fill_in "Opening time", with: @gym_hour.opening_time.to_s
    click_on "Update Gym hour"

    assert_text "Gym hour was successfully updated"
    click_on "Back"
  end

  test "should destroy Gym hour" do
    visit gym_hour_url(@gym_hour)
    click_on "Destroy this gym hour", match: :first

    assert_text "Gym hour was successfully destroyed"
  end
end
