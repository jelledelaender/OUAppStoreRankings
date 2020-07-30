require 'date'
load "dataprocessor.rb"
require "sqlite3"


def main
  ## FROM ARGS...
  start_date_input = "2020-07-25"
  end_date_input = "2020-07-26"

  begin
    start_date = Date.parse start_date_input
    end_date = Date.parse end_date_input
  rescue Exception => e
   puts "Exception: #{e}"
   exit
  end

  if end_date < start_date
    puts "EndDate is before startDate"
    exit
  end

  ## Start

  puts "StartDate: #{start_date}"
  puts "EndDate: #{end_date}"
  puts "-------------"

  date = start_date

  db = SQLite3::Database.new "OURanking.sqlite"
  db.execute "delete from apps" ## Debugging - emptying data set


  while date <= end_date
    dataProcessor = DataProcessor.new(db, date)
    dataProcessor.process
    
    date = date.next_day
  end

end

main