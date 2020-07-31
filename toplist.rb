require "sqlite3"

def main
  db_location = "OURanking.sqlite"

  ## Loading data from arguments
  arg_length = ARGV.length
  if arg_length > 1
    puts "Incorrect usage."
    puts "Usage: ruby toplist.rb <optional: DB Location>"
    exit
  end

  db_location = ARGV[0] if arg_length > 0


  db = SQLite3::Database.new db_location

  ###

  ## SELECT name, count(*) as counter, AVG(rank) as average_position FROM apps WHERE category = "free" AND device = "iphone" GROUP BY app_id ORDER BY average_position ASC

end

main