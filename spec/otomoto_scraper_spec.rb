require 'rspec'
require_relative '../otomoto_scraper'

def check_data_correctness(cars)
  cars.each do |car|
    return false if car.brand == "" or car.model == "" or car.mileage == "" or car.fuel_type == "" \
      or car.gearbox == "" or car.year_of_production == "" or car.photo_link == ""
    return true
  end
end

RSpec.describe do
  describe "Czy wszystkie dane są poprawnie wczytane" do
    it "Strony 1-4" do
      otomoto_scraper = OtomotoScraper.new(1, 4)
      otomoto_scraper.run()
      expect(check_data_correctness(otomoto_scraper.cars)).to eq(true)
    end
    it "Strony 501-504" do
      otomoto_scraper = OtomotoScraper.new(501, 504)
      otomoto_scraper.run()
      expect(check_data_correctness(otomoto_scraper.cars)).to eq(true)
    end
  end
end
