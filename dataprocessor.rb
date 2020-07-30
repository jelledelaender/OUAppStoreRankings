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
      app["os"],
      app["name"],
      app["rank"],
      app["version"],
      app["rating"],
      app["rating_for_current_version"],
      app["global_rating_count"],
      app["rating_count_for_current_version"],
      app["canonical_country"],
      app["categories"].to_s,
      app["url"],
      app["support_url"],
      app["website_url"],
      app["privacy_policy_url"],
      app["eula_url"],
      app["release_date"],
      app["updated_date"],
      app["humanized_worldwide_last_month_downloads"]["downloads"],
      app["humanized_worldwide_last_month_revenue"]["revenue"],
      app["price"],
      (app["in_app_purchases"] ? 1 : 0),   
      (app["shows_ads"] ? 1 : 0),
      (app["buys_ads"] ? 1 : 0),
      (app["apple_watch_enabled"] ? 1 : 0),
      (app["imessage_enabled"] ? 1 : 0),
      app["icon_url"]
    ]

    @db.execute "insert into apps values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", db_structure

  end

end