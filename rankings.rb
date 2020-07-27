require 'net/http'
require 'uri'
require "resolv-replace.rb"
require 'json'

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
      puts "Invalid HTTP Code: #{res.code}"
      nil
  end
end

url = "https://sensortower.com/api/ios/rankings/get_category_rankings?category=0&country=BE&date=2020-07-26T00%3A00%3A00.000Z&device=IPHONE&limit=2&offset=0"

data = download(url)

puts "Data #{data}"