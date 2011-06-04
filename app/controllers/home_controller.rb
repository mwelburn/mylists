API_VERSION = '2010-04-01'

# Twilio AccountSid and AuthToken
ACCOUNT_SID = 'ACeea0c0fc24e275f78e1ac360ab482dd7'
ACCOUNT_TOKEN = '264b643478d06f6d4a165dcb2dbf96f7'

class HomeController < ApplicationController

  def index
    logger.debug session["devise_foursquare_data"]
  end

  def foursquare
    if data = session["devise_foursquare_data"] && session["devise_foursquare_data"]["credentials"]
      oauth_token = data["token"]
    end
logger.debug session["devise_foursquare_data"]
    if data = session["devise_foursquare_data"] && session["devise_foursquare_data"]["extra"]["user_hash"]
      user_id = data["id"]
    end

    client = Foursquare2::Client.new(:oauth_token => oauth_token)

    user = client.user(params[:id])

    render :text => user
  end

  def twilio
#    phone = "5743150289"
    phone = "6302766871"
    if (params[:phone])
      phone = params[:phone]
    end
    twilioPhone = "2138634225"

    account = Twilio::RestAccount.new(ACCOUNT_SID, ACCOUNT_TOKEN)

    resp = account.request("/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/SMS/Messages.json",  'GET')
    resp.error! unless resp.kind_of? Net::HTTPSuccess
    #render :text => "code: %s\nbody: %s" % [resp.code, resp.body]

    #render :text => resp.body

    smsArray = ""

    body = resp.body
    parsed_body = ActiveSupport::JSON.decode(body)
    parsed_body["sms_messages"].each do |smsMsg|
      if smsMsg.from.include? phone
         smsArray << smsMsg.body
      end
    end

    #render :text => smsArray
    args = {"From" => twilioPhone, "To" => phone, "Body" => smsArray}
    resp = account.request("/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/SMS/Messages", 'POST', args)
    render :text => resp
  end

end
