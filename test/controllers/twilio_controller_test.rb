require 'test_helper'

class TwilioControllerTest < ActionController::TestCase

  test "should request better input when question is malformed" do
    post :sms, { "Body" => "Blah blah blah" }
    assert_response :success
    assert_select "sms", 'Ask me for the local time ' +
                         '(e.g., "What time is it in San Francisco?").'
  end
  
  test "should return a time for Tucson, AZ" do
    post :sms, { "Body" => "What time is it in Tucson, AZ?" }
    assert_response :success
    assert_select "sms", /^The time is .* in Tucson, AZ, USA.$/
  end
  
  test "should return the error when the location does not exist" do
    post :sms, { "Body" => "What time is it in DOESNOTEXISTXYZ?" }
    assert_response :success
    assert_select "sms", "ZERO_RESULTS"
  end
end