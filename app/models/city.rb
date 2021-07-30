class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    self.listings.select do |listing|
      listing.reservations.none? do |res|
        res.checkin <= Date.parse(end_date) && res.checkout >= Date.parse(start_date)
      end
  end
end

# knows the city with the highest ratio of reservations to listings
# doesn't hardcode the city with the highest ratio of reservations to listings
def self.highest_ratio_res_to_listings
  highest_ratio_city = nil
  highest_ratio = 0
  City.all.each do |city|

    sum_of_listings = city.listings.count
    sum_of_reservations = 0

    city.listings.each do |listing|
      sum_of_reservations += listing.reservations.count
    end

    ratio_reservations_listings = sum_of_reservations / sum_of_listings

    if ratio_reservations_listings > highest_ratio
      highest_ratio = ratio_reservations_listings
      highest_ratio_city = city
    end
  end
  highest_ratio_city
end

# knows the city with the most reservations
def self.most_res
  most_reserved_city = nil
  highest_res = 0
  City.all.each do |city|

    sum_of_reservations = 0

    city.listings.each do |listing|
      sum_of_reservations += listing.reservations.count
    end

    if sum_of_reservations > highest_res
      highest_res = sum_of_reservations
      most_reserved_city = city
    end
  end
  most_reserved_city
end



end

