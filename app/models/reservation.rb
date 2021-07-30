class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout

  validate :guest_is_not_host
  validate :checkin_before_checkout
  validate :available_for_chosen_period

  def guest_is_not_host
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "Can't be the same as the host")
    end
  end

  def checkin_before_checkout
    if self.checkin && self.checkout
      if self.checkin > self.checkout or self.checkin == self.checkout
        errors.add(:checkin, "Must be before the checkout time")
      end
    end
  end

  def available_for_chosen_period
    if self.checkin && self.checkout
      self.listing.reservations.each do |res|
        if res.checkin <= self.checkout && res.checkout >= self.checkin
          errors.add(:checkin, "Already taken!")
        end
      end
    end
  end
  

  def duration
    days = self.checkout - self.checkin
    days.to_i
  end

  def total_price
    self.listing.price * self.duration
  end

end
