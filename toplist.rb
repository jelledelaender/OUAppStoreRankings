require "sqlite3"

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

  if type == "iphone" || type == "ipad"
    result = db.query( "SELECT name, MIN(rank) AS min_position, ROUND(AVG(rank), 3) AS average_position, MAX(rank) AS max_position, count(*) AS number_of_days, ROUND(AVG(rank) / count(*), 3) AS popularity FROM apps WHERE category = ? AND device = ? GROUP BY app_id ORDER BY popularity ASC  LIMIT ?", category, type, limit)
  else 
    result = db.query( "SELECT name, MIN(rank) AS min_position, ROUND(AVG(rank), 3) AS average_position, MAX(rank) AS max_position, count(*) AS number_of_days, ROUND(AVG(rank) / count(*), 3) AS popularity FROM apps WHERE category = ? GROUP BY app_id ORDER BY popularity ASC  LIMIT ?", category, limit)
  end




  result.each do |u|
    p u
  end

end

main