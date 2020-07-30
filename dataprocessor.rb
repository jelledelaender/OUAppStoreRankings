load "downloader.rb"

class DataProcessor

  def initialize(db, date)
    @db = db
    @date = date
  end

  def process
    puts "Loading data for #{@date}"
  
    data = Downloader.get_data_for_date @date
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
        process_app item
      else
        puts "Unexpected item: #{item}"
      end
    end
  end

  def process_app app
   
    db_structure = [
      @date.to_s,
      app["app_id"],
      app["name"],
      app["rank"],
      app["version"],
      app["rating"],
      app["rating_for_current_version"],
      app["rating_count"],
      app["rating_count_for_current_version"],
      app["canonical_country"],
      app["categories"],
      app["url"]
    ]

    @db.execute "insert into apps values (?,?,?,?,?,?,?,?,?,?,?,?)", db_structure

  end

end