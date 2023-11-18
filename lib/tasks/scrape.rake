desc "Scrape"
task({ :scrape_ping => :environment }) do

  # Making an HTTP request test
  response = HTTParty.get('https://books.toscrape.com/')
  if response.code == 200
      puts "Scrape success" #response.body
  else
      puts "Error: #{response.code}"
      exit
  end
end

task({ :scrape_parse => :environment }) do
  # Parsing HTML with Nokogiri
  ## get one page easily, for demo/testing purposes
  #document = Nokogiri::HTML4(response.body)
  #puts document
 
  ## get a 3 pages and scrape
  books = []
  3.times do |i|
    url = "https://books.toscrape.com/catalogue/page-#{i + 1}.html"
    response = HTTParty.get(url)
    document = Nokogiri::HTML(response.body)
    all_book_containers = document.css('article.product_pod')

    all_book_containers.each do |container|
      title = container.css('.image_container > a > img').first['alt']
      price = container.css('.price_color').text.delete('^0-9.')
      availability = container.css('.availability').text.strip
      book = [title, price, availability]
      #
      ## books << book
      pp book
    end
  end
end

task({ :scrape_parse_csv => :environment }) do
  CSV.open('books.csv', 'w+',
          write_headers: true,
          headers: %w[Title Price Availability]) do |csv|
            
    50.times do |i|
      url = "https://books.toscrape.com/catalogue/page-#{i + 1}.html"
      response = HTTParty.get(url)
      document = Nokogiri::HTML(response.body)
      all_book_containers = document.css('article.product_pod')

      all_book_containers.each do |container|
        title = container.css('h3 a').first['title']
        price = container.css('.price_color').text.delete('^0-9.')
        availability = container.css('.availability').text.strip
        book = [title, price, availability]

        csv << book
      end
    end
  end
  
end
