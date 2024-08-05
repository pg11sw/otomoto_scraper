require_relative 'otomoto_scraper'

first = ARGV[0] ? ARGV[0] : "1"
last = ARGV[1] ? ARGV[1] : "4"

if ARGV.size <= 2 and first.match?(/^[1-9]\d*$/) and last.match?(/^[1-9]\d*$/) then
  otomoto_scraper = OtomotoScraper.new(first.to_i, last.to_i)
  otomoto_scraper.run()
  otomoto_scraper.create_csv()
  otomoto_scraper.create_pdf()
else
  puts "\e[31mUżycie:\e[0m"
  puts "\e[96mruby start.rb\e[0m \e[32m[first]\e[0m \e[95m[last]\e[0m"
  puts "\e[91mArgumenty powinny być liczbami całkowitymi większymi lub równymi 1."
  puts "Argumenty określają pierwszą i ostatnią stronę do ściągnięcia z otomoto.pl (domyślnie 1-4).\e[0m"
end
