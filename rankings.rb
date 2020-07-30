require 'net/http'
require 'uri'
require "resolv-replace.rb"
require 'json'
require 'date'

def download url 
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.read_timeout = 15
  if uri.port == 443 || url.start_with?('https://')
    http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  request = Net::HTTP::Get.new uri.request_uri
  request.initialize_http_header({"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36"}) ## Spoofing Safari UA
  res = http.request(request)

  case res
    when Net::HTTPSuccess then
      JSON.parse(res.body)
    when Net::HTTPRedirection then
      location = res['location']
      if res['location'].length > 0 && res['location'].include?("://") == false ## Follow non-absolute redicts
        location = "#{URI.join(url, res['location'])}" ## Sending URL as string
      end
      puts "Redirect dedetected: #{location}"
      download location
    else # Invalid HTTP Code
      puts "Invalid HTTP Code: #{res.code}: #{res.body}"
      nil
  end
end


def process_date date
  puts "Loading data for #{date}"

  url = "https://sensortower.com/api/ios/rankings/get_category_rankings?category=0&country=BE&date=#{date}T00%3A00%3A00.000Z&device=IPHONE&limit=2&offset=0"
  data = download(url)

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

  while date <= end_date
    process_date date
    date = date.next_day
  end

end

main