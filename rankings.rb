require 'date'
load "dataprocessor.rb"

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

  dataProcessor = DataProcessor.new

  while date <= end_date
    dataProcessor.process_date date
    date = date.next_day
  end

end

main