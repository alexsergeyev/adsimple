require File.dirname(__FILE__) + '/spec_helper'

describe "AdSimple" do
  include Rack::Test::Methods

  def app
    @app ||= AdSimple.new
  end

  describe "get /a/12356.iframe" do
    it "should return iframe content" do
      get '/a/12356.iframe'
      last_response.should be_ok
      last_response.headers["Set-Cookie"].should =~ /^ads=/
      last_response.should have_selector ('a') do |link|
        link.should have_selector ('img')
      end
    end
  end

  describe "get /a/12356.click" do
    it "should redirect" do
      get '/a/12356.click'
      last_response.original_headers["Set-Cookie"].should =~ /^ads=/
      last_response.headers["Location"].should == "http://example.com"
    end
  end

  describe "get /report.html" do
    it "should redirect" do
      get '/a/12356.click'
      last_response.original_headers["Set-Cookie"].should =~ /^ads=/
      last_response.headers["Location"].should == "http://example.com"
    end
  end

end
