require "sqlite3"
load "lib/pretty_table.rb"

def main
  db_location = "OURanking.sqlite"
  limit = 50

  ## Loading data from arguments
  arg_length = ARGV.length
  if arg_length < 2 || arg_length > 4
    puts "Incorrect usage."
    puts "Usage: ruby toplist.rb <free/paid/grossing> <iphone/ipad/all> <optional:limit> <optional:DB Location>"
    exit
  end

  ## Category check
  category = ARGV[0]
  if ["free","paid","grossing"].include?(category) == false
    puts "Type must be free, paid or grossing"
    exit
  end


  ## Type check
  type = ARGV[1]
  if ["iphone","ipad","all"].include?(type) == false
    puts "Type must be iphone, ipad or all"
    exit
  end


  limit = ARGV[2] if arg_length > 2

  ## Alternative DB_Location
  db_location = ARGV[3] if arg_length > 3

  ## Generate toplist
  db = SQLite3::Database.new db_location
  db.results_as_hash = true

  if type == "iphone" || type == "ipad"
    result = db.query( "SELECT '' as ind, name, MIN(rank) AS min_position, printf('%.3f', AVG(rank)) AS average_position, MAX(rank) AS max_position, count(*) AS number_of_days, printf('%.3f', AVG(rank) / count(*)) AS popularity, app_id FROM apps WHERE category = ? AND device = ? GROUP BY app_id ORDER BY popularity ASC  LIMIT ?", category, type, limit)
  else 
    result = db.query( "SELECT '' as ind, name, MIN(rank) AS min_position, printf('%.3f', AVG(rank)) AS average_position, MAX(rank) AS max_position, count(*) AS number_of_days, printf('%.3f', AVG(rank) / count(*)) AS popularity, app_id FROM apps WHERE category = ? GROUP BY app_id ORDER BY popularity ASC  LIMIT ?", category, limit)
  end

  labels = {"ind"=>"#", "name"=> "App Name", "min_position"=> "Lowest position", "average_position"=> "Average position", "max_position"=> "Highest position", "number_of_days"=> "Nr of days", "popularity"=> "Popularity", "app_id"=>"App ID"}
  table = PrettyTable.new labels

  i = 1
  result.each do |u|
    new_u = Hash[u.map{|k,v| [k,v.to_s] } ] ## Ensuring all objects are a string
    new_u["ind"] = i.to_s
    table.add_line new_u

    i = i + 1
  end

  table.print
end

main