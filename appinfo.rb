# AppInfo.rb
# 
# Objective of AppInfo.rb is to give a visualisation of all known data ofa given application.
# This script can be called with the AppID as parameter, and optional the path of the database.
# The script will then print all enters, ranking and more which can be used for debugging or analysing entries.
# 
# Usage
# ruby toplist.rb <appid> <optional:DB Location>
# 
#

require "sqlite3"

def main
  db_location = "OURanking.sqlite"

  ## Loading data from arguments
  arg_length = ARGV.length
  if arg_length < 1 || arg_length > 2
    puts "Incorrect usage."
    puts "Usage: ruby toplist.rb <appid> <optional:DB Location>"
    exit
  end

  ## AppID
  app_id = ARGV[0]

  ## Alternative DB_Location
  db_location = ARGV[1] if arg_length > 1

  ## App info
  db = SQLite3::Database.new db_location
  db.results_as_hash = true

  result = db.query( "SELECT name, count(*) as times_seen_in_database, min(rank) as min_rating, avg(rank) as avg_rating, max(rank) as max_rating, GROUP_CONCAT(distinct privacy_policy_url) as privacy_g_url, GROUP_CONCAT(distinct url) as url_g, GROUP_CONCAT(distinct support_url) as support_url_g, GROUP_CONCAT(distinct website_url) as website_url_g, GROUP_CONCAT(distinct eula_url) as eula_url_g, * FROM apps WHERE app_id = ? ORDER BY date DESC LIMIT 1", app_id)

  result.each do |u|
    u.keys.each do |key|
      puts "#{key}: #{u[key]}"
    end
  end
end

main