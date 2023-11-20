# rails console:
## require 'rake'
## Rails.application.load_tasks
## Rake::Task['scrape_parse'].invoke
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
 
  ## get n_pages.times pages of article.product_pod
  n_pages=1
  ratings_hash = {One: 1, Two: 2, Three: 3, Four: 4, Five: 5 }
  books = []
  n_pages.times do |i|
    url = "https://books.toscrape.com/catalogue/page-#{i + 1}.html"
    response = HTTParty.get(url)
    document = Nokogiri::HTML(response.body)
    # all books on this page:
    all_book_containers = document.css('article.product_pod')
    once=true
    all_book_containers.each do |container|
      title = container.css('.image_container > a > img').first['alt']
      price = container.css('.price_color').text.delete('^0-9.')
      availability = container.css('.availability').text.strip 
      # example 1: title in H3 as well
      # debugger
      ## rails console with debugger
      ## container.css("h3")
      ## container.css("h3").first
      ## container.css("h3").first.class
      ##   => Nokogiri::XML::Element
      ## container.css("h3").first.children.first['title']
      ##   => "A Light in the Attic"
      title = container.css('.image_container > a > img').first['alt']
      #title_too = container.css("h3").first.children.first['title']
      #pp "#{title} #{title_too}"

      ## example 2: getting the rating
      ## container.css('.star-rating').first.attr("class") 
      ##    => "star-rating Three"
      ## container.css('.star-rating').first.attr("class").gsub("star-rating ","")
      ##    => "Three"
      rating_str = container.css('.star-rating').first.attr("class").gsub("star-rating ","")
      rating_int = ratings_hash[rating_str.to_sym]

      book = [title, price, availability, rating_int]
      # add to array array of books:
      ## books << book
      pp book
    end
  end
end

task({ :scrape_parse_csv => :environment }) do
  #CSV.open('books.csv', 'w+',
  #        write_headers: true,
  #        headers: %w[Title Price Availability]) do |csv|
  ratings_hash = {One: 1, Two: 2, Three: 3, Four: 4, Five: 5 }
  file_name = 'books.csv'
  CSV.open(file_name, 'w+',
          write_headers: true,
          headers: %w[Title Price Availability Rating]) do |csv|
    rows = 0          
    50.times do |i|
      url = "https://books.toscrape.com/catalogue/page-#{i + 1}.html"
      response = HTTParty.get(url)
      document = Nokogiri::HTML(response.body)
      all_book_containers = document.css('article.product_pod')
      pp "Parsing #{url}"
      all_book_containers.each do |container|
        title = container.css('h3 a').first['title']
        price = container.css('.price_color').text.delete('^0-9.')
        availability = container.css('.availability').text.strip
        rating_str = container.css('.star-rating').first.attr("class").gsub("star-rating ","")
        rating_int = ratings_hash[rating_str.to_sym]
        book = [title, price, availability, rating_int]

        csv << book # add this row to the csv
      end
      rows += all_book_containers.size
    end # .times do |i|
    pp "Saved #{rows} rows & heading to #{file_name}"
  end # CSV.open
end

# Scrape dynamic page
task({ :scrape_parse_dynamic => :environment }) do
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--ignore-certificate-errors')
  options.add_argument('--disable-popup-blocking')
  options.add_argument('--disable-notification')
  options.add_argument('--disable-translate')
  options.add_argument('--headless=new') # try without
  driver = Selenium::WebDriver.for :chrome, options: options
  driver.navigate.to 'https://quotes.toscrape.com/js/'
  quotes = driver.find_elements(class: 'quote')
  quotes.each {|q|
    #pp q.text
    #pp q.attr("class")
    quote_text = q.find_element(class: 'text').text
    author =  q.find_element(class: 'author').text
    puts "#{author}: #{quote_text}"
    #debugger
  }
end

task({ :scrape_parse_csv_dynamic => :environment }) do
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--ignore-certificate-errors')
  options.add_argument('--disable-popup-blocking')
  options.add_argument('--disable-notification')
  options.add_argument('--disable-translate')
  options.add_argument('--headless=new') # try without
  driver = Selenium::WebDriver.for :chrome, options: options
  driver.navigate.to 'https://quotes.toscrape.com/js/'
  quotes = driver.find_elements(class: 'quote')

  file_name = 'quotes.csv'
  CSV.open(file_name, 'w+',
          write_headers: true,
          headers: %w[Author Quote]) do |csv|
    quotes.each {|q|
      quote_text = q.find_element(class: 'text').text
      author =  q.find_element(class: 'author').text
      puts "#{author}: #{quote_text}"
      csv << [author, quote_text] 
    }
  end 
end

# store in an active record instead of csv

# open a csv and make use of it
## store in active record
## make a chart