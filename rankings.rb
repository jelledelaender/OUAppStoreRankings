require 'date'
load "lib/dataprocessor.rb"
require "sqlite3"

def main
  ## Default values
  number_of_days = 7
  db_location = "OURanking.sqlite"
  clear_database = false

  ## Loading data from arguments
  arg_length = ARGV.length
  if arg_length < 1 || arg_length > 3
    puts "Incorrect usage."
    puts "Usage: ruby rankings.rb <number_of_days> <optional: Clear database {true/false}> <optional: DB Location>"
    exit
  end

  number_of_days = ARGV[0].to_i
  clear_database = (ARGV[1] == "true") if arg_length > 1
  db_location = ARGV[2] if arg_length > 2

  ## Valiating inputs
  end_date = Date.today.prev_day
  start_date = end_date.prev_day(number_of_days - 1) ##Distracting one day as we'll still do the last day

  if number_of_days < 1
    puts "Minimal 1 day timespan. Setting to 1 day timespan"
    start_date = end_date
  end

  if number_of_days > 90
    puts "Maximal 90 days supported at the moment. Settin to 90 days timespan"
    start_date = end_date.prev_day(90)
  end

  ## Start
  puts "StartDate: #{start_date}"
  puts "EndDate: #{end_date}"
  puts "-------------"

  db = SQLite3::Database.new db_location
  if clear_database
    puts "Clearing database"
    db.execute "delete from apps" 
  end

  date = start_date
  while date <= end_date
    dataProcessor = DataProcessor.new(db, date)
    dataProcessor.process

    date = date.next_day
  end

  puts "Finished"
end

main