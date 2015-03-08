require 'twilio-ruby'
 
class TwilioController < ApplicationController
  include Webhookable
  include TwilioHelper

  after_filter :set_header
 
  skip_before_action :verify_authenticity_token
 
  def sms
    response = Twilio::TwiML::Response.new do |r|
      r.sms current_time(params["Body"])
=begin
,
            to: params["From"], 
=end            from: params["To"]
    end
    
    render_twiml response
  end
end