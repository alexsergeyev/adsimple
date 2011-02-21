require 'yaml'
require 'mysql2'
desc "setup initial db"
namespace :db do
  task :setup do
    DB = Mysql2::Client.new(YAML.load_file('config/db.yaml').inject({}) { |res, (k, v)| res[k.to_sym] = v; res })
    DB.query("CREATE TABLE IF NOT EXISTS report (ad_id INT UNSIGNED NOT NULL DEFAULT '0', user_id BIGINT UNSIGNED NOT NULL DEFAULT '0', impressions INT UNSIGNED NOT NULL DEFAULT '0', clicks INT UNSIGNED NOT NULL DEFAULT '0')")
    begin
      DB.query("ALTER TABLE report ADD UNIQUE KEY ads_user(ad_id, user_id)")
    rescue
      puts "DB already created"
    end
  end
end