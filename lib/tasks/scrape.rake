response = HTTParty.get('https://books.toscrape.com/')
if response.code == 200
    puts response.body
else
    puts "Error: #{response.code}"
    exit
end