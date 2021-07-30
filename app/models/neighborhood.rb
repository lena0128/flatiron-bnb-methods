class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings


# Date.parse => given representation of date and time, and creates a DateTime object.  
  def neighborhood_openings(start_date, end_date)
   self.listings.select do |listing|
    listing.reservations.none? do |res|
      res.checkin <= Date.parse(end_date) && res.checkout >= Date.parse(start_date)
    end
  end
end

def self.most_res
  most_reserved_neighborhood = nil
  highest_res = 0
  Neighborhood.all.each do |neighborhood|

    sum_of_reservations = 0

    neighborhood.listings.each do |listing|
      sum_of_reservations += listing.reservations.count
    end

    if sum_of_reservations > highest_res
      highest_res = sum_of_reservations
      most_reserved_neighborhood = neighborhood
    end
  end
  most_reserved_neighborhood
end

def self.highest_ratio_res_to_listings
  highest_ratio_neighborhood = nil
  highest_ratio = 0
  Neighborhood.all.each do |neighborhood|

    sum_of_listings = neighborhood.listings.count
    sum_of_reservations = 0

    neighborhood.listings.each do |listing|
      sum_of_reservations += listing.reservations.count
    end

    if sum_of_listings != 0 
      ratio_reservations_listings = sum_of_reservations / sum_of_listings
    else
      ratio_reservations_listings = 0
    end

    if ratio_reservations_listings > highest_ratio
      highest_ratio = ratio_reservations_listings
      highest_ratio_neighborhood = neighborhood
    end
  end
  highest_ratio_neighborhood
end

end
