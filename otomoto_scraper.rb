require 'open-uri'
require 'httparty'
require 'nokogiri'
require 'csv'
require 'wicked_pdf'
require_relative 'car.rb'

# Główna klasa - odpowiedzialna za ściągnięcie danych, przefiltrowanie ich i zapisanie wyników do plików csv i pdf.
class OtomotoScraper
  # Tablica obiektów reprezentujących samochdy
  # * Array of Car objects
  attr_accessor :cars

  # Tworzy tablicę @cars, która będzie przechowywać obiekty typu Car.
  # Przyjmuje liczby określające zakres stron do ściągnięcia.
  # * first - integer
  # * last - integer
  def initialize(first, last)
    @cars = Array.new
    @first = first
    @last = last
  end

  # Ściąga strony, przefiltrowuje je i zapisuje istotne dane do tablicy @cars.
  def run()
    (@first..@last).each do |n|
      url = "https://www.otomoto.pl/osobowe/bmw?page=#{n}"
      #html = URI.open(url).read
      html = HTTParty.get(url).body

      doc = Nokogiri::XML(html)
      xml = doc.to_xml

      data = doc.xpath('//article/section')
      data.each do |car|
        model = car.at_xpath('./div[2]/h1').text
        mileage = car.at_xpath('./div[3]/dl[1]/dd[1]').text
        fuel_type = car.at_xpath('./div[3]/dl[1]/dd[2]').text
        gearbox = car.at_xpath('./div[3]/dl[1]/dd[3]').text
        year_of_production = car.at_xpath('./div[3]/dl[1]/dd[4]').text
        photo_link = car.at_xpath('.//img/@src').to_s
        photo_link = photo_link.gsub(";s=320x240", "")
        @cars.push(Car.new("BMW", model, mileage, fuel_type, gearbox, year_of_production, photo_link))
      end
    end
  end

  # Tworzy plik csv na podstawie samochodów zapisanych w tablicy @cars.
  def create_csv()
    CSV.open("cars.csv", "w") do |csv|
      csv << ["brand", "model", "mileage", "fuel_type", "gearbox", "year_of_production", "photo_link"]
      @cars.each do |car|
        csv << [car.brand, car.model, car.mileage, car.fuel_type, car.gearbox, car.year_of_production, car.photo_link]
      end
    end
  end

  # Tworzy plik pdf na podstawie samochodów zapisanych w tablicy @cars.
  def create_pdf()
    html = <<-HTML
    <html>
    <head>
      <meta charset="utf-8">
      <style>
        body { font-family: Arial, sans-serif; font-size: 20px; margin: 50px }
        h1 { color: blue; }
        h2 {color: gray;}
        section {
          break-inside: avoid;
          display: flex;
          flex-direction: column;
          margin-top: 100px;
          margin-bottom: 100px;
        }
        .top {
          text-align: center;
          border: 5px solid black;
          margin-bottom: 30px;
        }
        .bottom {
          display: flex;
          flex-direction: row;
        }
        .data {
          width: 50%;
          display: flex;
          justify-content: center;
          align-items: center;
        }
        .image {
          width: 50%;
          display: flex;
          justify-content: center;
          align-items: center;
        }
        img {
          width: 100%;
        }
      </style>
    </head>
    <body>
      <h1>Samochody BMW z otomoto.pl</h1>
      <p>Strony #{@first} - #{@last}</p>
    HTML

    @cars.each do |car|
      html += <<-HTML
      <section>
        <div class="top">
          <h2> #{car.model} </h2>
        </div>
        <div class="bottom">
          <div class="image">
            <img src=#{car.photo_link}/>
          </div>
          <div class="data">
            <ul>
              <li> Przebieg: #{car.mileage} </li>
              <li> Rodzaj paliwa: #{car.fuel_type} </li>
              <li> Skrzynia biegów: #{car.gearbox} </li>
              <li> Rok produkcji: #{car.year_of_production} </li>
            </ul>
          </div>
        </div>
      </section>
      HTML
    end

    html += <<-HTML
    </body>
    </html>
    HTML

    pdf = WickedPdf.new.pdf_from_string(html)
    File.open("cars.pdf", "wb") do |file|
      file << pdf
    end
  end
end