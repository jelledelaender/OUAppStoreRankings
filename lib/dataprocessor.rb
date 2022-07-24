load "lib/downloader.rb"

class DataProcessor
  @@count = 50

  def initialize(db, date)
    @db = db
    @date = date
  end

  def process
    puts "Loading data for #{@date}"

    process_for_device "iphone"
    process_for_device "ipad"
  end

  def process_for_device device
    puts "Loading data for #{@date} device #{device} (top #{@@count})"
  
    ## Delete old data for date - device
    puts "Deleting older entries for #{@date} and device #{device}"
    @db.execute "delete from apps where device = ? and date = ?", device, @date.to_s

  
    data = Downloader.get_data_for_date(@date, device, @@count)
    if data == nil
      return nil
    end
  
    ## Process data - dumb in DB to be processed
    if data.kind_of?(Array)
      process_array_with_apps(data, device)
    else
      puts "Expected Array. Received data #{data}"
    end
  
  end
  
  def process_array_with_apps(list, device)
    list.each do |item|
      process_app(item[0], "free", device)
      process_app(item[1], "paid", device)
      process_app(item[2], "grossing", device)
    end
  end

  def process_app(app, category, device)

    if app.count == 0
      return ## Ignore empty datasets
    end

    db_structure = [
      @date.to_s,
      app["app_id"],
      category,
      device,
      app["rank"],
      app["name"],
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

    @db.execute "insert into apps values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", db_structure

  end

end