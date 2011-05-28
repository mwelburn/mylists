API_VERSION = '2010-04-01'

# Twilio AccountSid and AuthToken
ACCOUNT_SID = 'ACeea0c0fc24e275f78e1ac360ab482dd7'
ACCOUNT_TOKEN = '264b643478d06f6d4a165dcb2dbf96f7'

class HomeController < ApplicationController

  def index
    @hello = "hello"
  end

  def twilio
    account = Twilio::RestAccount.new(ACCOUNT_SID, ACCOUNT_TOKEN)

    resp = account.request("/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/SMS/Messages.json",  'GET', {})
    resp.error! unless resp.kind_of? Net::HTTPSuccess
    puts "code: %s\nbody: %s" % [resp.code, resp.body]
  end

end
