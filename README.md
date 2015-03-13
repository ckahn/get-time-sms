## Receive Time for Any Location via SMS
This Rails app uses Twilio and two Google APIs to process and properly respond 
to SMS messages that request the local time for a specified address.

When an SMS message like "What time is it in New York, NY?" or "Give me the
time for Paris" is sent to the Twilio number, Twilio responds with a message 
like "The time is 12:00AM in Paris, France."