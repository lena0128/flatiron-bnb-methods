class Listing < ActiveRecord::Base
  #callback methods below
  before_create :set_user_as_host
  before_destroy :set_user_as_user

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  def set_host_true
    self.host.host = true if !self.host.host?
    self.host.save
  end

  def set_host_false
    self.host.host = false if !Listing.find_by(host: self.host)
    self.host.save
  end

  # knows its average ratings from its reviews
  def average_review_rating
    ratings = []
    self.reviews.each do |review|
      ratings << review.rating
    end
    ratings.sum.fdiv(ratings.size) # div returns the floating point result after division of two numbers.
  end

end
