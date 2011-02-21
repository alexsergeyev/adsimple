require 'mysql2'
require 'sinatra'
require 'haml'
require 'ostruct'
require 'yaml'
class AdSimple < Sinatra::Base
  set :environment, 'production'
  set :views, File.dirname(__FILE__) + '/../views'
  set :public, "public"

  configure do
    DB          = Mysql2::Client.new(YAML.load_file('config/db.yaml').inject({}){|res,(k,v)| res[k.to_sym] = v; res})
    COOKIE_NAME = "ads"
    ADS         = YAML.load_file('config/ads.yaml')
    #HEADERS = ['HTTP_REFERER', 'HTTP_ACCEPT_LANGUAGE', 'HTTP_USER_AGENT', 'REMOTE_ADDR']
  end

  helpers do
    # Generate unique sequenced id (16-18 digits)
    def uniq_id
      (("%.4f" % (Time.now - Time.mktime(2011, 1, 1, 0, 0, 0)))).to_s.tr('.', '')+("%.3s" % Process.pid.to_s.reverse).to_s+"01".to_s
    end

    # Pick ad from config returns hash {"id" =>, "img" => ... , "url" => ..}
    def get_ad(id)
      ADS[id].nil? ? nil : ADS[id].merge({"id" => id})
    end
  end

  get '/' do
    # Demo page
    redirect '/index.html'
  end

  get '/a/:id.:type' do
    req         = OpenStruct.new()
    req.ad_id   = params[:id] || 0 # Default ID
    req.user_id = request.cookies[COOKIE_NAME] || uniq_id
    req.type    = params[:type] || "unknown"

    # Refresh expiry time/Set cookies
    response.set_cookie(COOKIE_NAME, {:value => req.user_id, :expires => Time.now + 60*60*24*30})

    #req.user_headers = request.env.inject({}) do |c, (k,v) |
    #  ( HEADERS.include?(k) ? c.merge(k => v) : c)
    #end

    @ad = get_ad(req.ad_id)
    not_found if @ad.nil?

    case req.type
      when 'iframe'
        DB.query("INSERT INTO report(ad_id,user_id,impressions) VALUES (#{req.ad_id.to_i}, #{req.user_id.to_i},1) ON DUPLICATE KEY UPDATE impressions=impressions+1")
        haml :iframe
      when 'click'
        DB.query("INSERT INTO report(ad_id,user_id,clicks) VALUES (#{req.ad_id.to_i}, #{req.user_id.to_i},1) ON DUPLICATE KEY UPDATE clicks=clicks+1")
        redirect get_ad(req.ad_id)["url"], 302
      else
        not_found
    end
  end

  get '/report.:format' do
    @header = %w(ad_id unique_clicks clicks contacts impressions)
    @result = DB.query("SELECT ad_id, sum(IF(clicks > 0,1,0)) as unique_clicks, sum(IF(impressions >0,1,0)) as contacts, sum(impressions) as impressions, sum(clicks) as clicks  FROM report GROUP BY ad_id;")

    # Create two-dimensional array of values [[ ad_id1, unique_click1, ... ], [ad_id2, unique_click2, ...]]
    @result = @result.map{|h| h.sort_by {|k,v| @header.index(k)}.map{ |n| n.last.to_i}}
    case params[:format]
      when 'html'
        haml :report
      when 'csv'
        content_type "text/csv"
        # Make tab-separated CSV file with header
        @header.join("\t")+"\n" + @result.map{|n| n.join("\t")}.join("\n")
    end
  end
end
