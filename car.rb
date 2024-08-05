#Przechowuje dane związane z konkretnym samochodem.
class Car
  # Marka
  # * string
  attr_accessor :brand
  # Model
  # * string
  attr_accessor :model
  # Przebieg
  # * string
  attr_accessor :mileage
  # Rodzaj paliwa
  # * string
  attr_accessor :fuel_type
  # Skrzynia biegów
  # * string
  attr_accessor :gearbox
  # Rok produkcji
  # * string
  attr_accessor :year_of_production
  # Link do zdjęcia
  # * string
  attr_accessor :photo_link

  # Przyjmuje dane związane z danym samochodem.
  # * wszystkie parametry są typu string
  def initialize(brand, model, mileage, fuel_type, gearbox, year_of_production, photo_link)
    @brand = brand
    @model = model
    @mileage = mileage
    @fuel_type = fuel_type
    @gearbox = gearbox
    @year_of_production = year_of_production
    @photo_link = photo_link
  end

  # Wyświetla dane związane z samochodem.
  def to_s
    return "[#{@brand}] [#{@model}] [#{@mileage}] [#{@fuel_type}] [#{@gearbox}] [#{@year_of_production}]\n"
  end

end