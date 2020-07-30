load "downloader.rb"

class DataProcessor

  def process_date date
    puts "Loading data for #{date}"
  
    data = Downloader.get_data_for_date date
  
    if data == nil
      return nil
    end
  
    ## Process data - dumb in DB to be processed
    if data.kind_of?(Array)
      process_array_with_apps data
    else
      puts "Expected Array. Received data #{data}"
    end
  
  end
  
  def process_array_with_apps list
    list.each do |item|
      if item.kind_of?(Array)
        process_array_with_apps item
      elsif item.kind_of?(Hash)
        puts "HASH: #{item}"
        exit
      else
        puts "Unexpected item: #{item}"
      end
    end
  end

end