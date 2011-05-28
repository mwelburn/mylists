API_VERSION = '2010-04-01'

# Twilio AccountSid and AuthToken
ACCOUNT_SID = 'ACeea0c0fc24e275f78e1ac360ab482dd7'
ACCOUNT_TOKEN = '264b643478d06f6d4a165dcb2dbf96f7'

class HomeController < ApplicationController

  def index
    @hello = "hello"
  end

  def foursquare
    client = Foursquare2::Client.new(:client_id => '4GI510HOP4UN1RT4F015WKIDH3JHQK3M1KZZV2AQHLMHGC3N', :client_secret => 'JX1YCRAVY4R0P4WUQSCCNWMMPOFGELBQAU2RYU13W4TE4FIK')
    #client = Foursquare2::Client.new(:oauth_token => 'OV4XQWEFQUJIUQTJ40YPR4GNCQGEJZC0EY1LPODQW4YBRODP')

    #userid = 785079
    userid = 10000273
    if (params[:id])
      userid = params[:id]
    end
    user = client.user(userid)
    #user = client.user(params[:id])
    #if user
    #   @checkins = client.user_checkins(params[:id])
    #end
    #@checkins = user.user_checkins
    render :text => user
    #render :text => user.user_checkins
  end

  def twilio
    account = Twilio::RestAccount.new(ACCOUNT_SID, ACCOUNT_TOKEN)

    resp = account.request("/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/SMS/Messages.json",  'GET')
    resp.error! unless resp.kind_of? Net::HTTPSuccess
    #render :text => "code: %s\nbody: %s" % [resp.code, resp.body]

    render :text => resp.body

#    body = resp.body
#    parsed_body = ActiveSupport::JSON.decode(body)
#    parsed_json["SMSMessage"].each do |smsMsg|
#      render :text => smsMsg
#    end
  end

end
