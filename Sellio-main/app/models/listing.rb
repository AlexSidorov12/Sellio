class Listing < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :user, optional: true
  has_many_attached :images
  
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  # Store extra fields as JSON
  serialize :extra_fields, coder: JSON if Rails.env.development? || Rails.env.test?
  
  # Helper methods for car-specific fields
  def license_plate
    extra_fields&.dig('license_plate')
  end
  
  def mileage
    extra_fields&.dig('mileage')
  end
  
  def engine_size
    extra_fields&.dig('engine_size')
  end
  
  def previous_owners
    extra_fields&.dig('previous_owners')
  end
  
  def year
    extra_fields&.dig('year')
  end
  
  def make
    extra_fields&.dig('make')
  end
  
  def model
    extra_fields&.dig('model')
  end
  
  def fuel_type
    extra_fields&.dig('fuel_type')
  end
  
  def transmission
    extra_fields&.dig('transmission')
  end
end


