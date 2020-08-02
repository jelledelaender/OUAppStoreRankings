require "sqlite3"
load "lib/pretty_table.rb"

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

  result = db.query( "SELECT name, count(*) as times_seen_in_database, min(rank) as min_rating, avg(rank) as avg_rating, max(rank) as max_rating, * FROM apps WHERE app_id = ? ORDER BY date DESC LIMIT 1", app_id)

  result.each do |u|
    u.keys.each do |key|
      puts "#{key}: #{u[key]}"
    end
  end
end

main