require 'test_helper'

class TwilioControllerTest < ActionController::TestCase

  test "should send helpful message if question is malformed" do
    post :sms, { "Body" => "Blah blah blah" }
    assert_response :success
    assert_select "sms", 'Ask me for the local time ' +
                         '(e.g., "What time is it in San Francisco?").'
  end
  
  test "should return the error when the location does not exist" do
    post :sms, { "Body" => "What time is it in DOESNOTEXISTXYZ?" }
    assert_response :success
    assert_select "sms", "ZERO_RESULTS"
  end
  
  test "should return the correct time for Greenwich, London" do
    post :sms, { "Body" => "What time is it in Greenwich, London?" }
    assert_response :success
    assert_select "sms", "The time is " +
                         "#{Time.now.utc.strftime("%l:%M%p").strip} " +
                         "in Greenwich, London SE10, UK."
  end
  
  test "should return a time for different question formats" do
    questions = ["What time is it in Tucson?", 
                 "Give me the time for Tucson.",
                 "Time in Tucson",
                 "Time for Tucson",
                 "What's the time at Tucson?"]
    questions.each do |question|
      post :sms, { "Body" => question }
      assert_response :success
      assert_select "sms", /^The time is.*/
    end
  end
end