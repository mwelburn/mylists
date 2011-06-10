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
#logger.debug session["devise_foursquare_data"]
    if data = session["devise_foursquare_data"] && session["devise_foursquare_data"]["extra"]["user_hash"]
      user_id = data["id"]
    end

    client = Foursquare2::Client.new(:oauth_token => oauth_token)

    user = client.user(params[:id])

    render :text => user
  end

  def test
    if user_signed_in?
      redirect_to twilio_path, :phone => current_user.phone
    end
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

  def foursquare_checkin
    json = JSON.parse request.body.string

    foursquare_user_id = json['user']['id']
    user = User.where(:foursquare_id => foursquare_user_id).first

    categories = json['checkin']['venue']['categories']

    if user.nil?
      puts "Foursquare user ID #{foursquare_user_id} not found"
    else
      #check this user's list and the venue to see what to send them!
      puts "Foursquare user ID #{foursquare_user_id} checked in #{categories}"
    end

    if user.phone
      redirect_to twilio_path, :phone => user.phone
    else
      puts "User doesn't have a registered phone number :("
    end

  end

end
