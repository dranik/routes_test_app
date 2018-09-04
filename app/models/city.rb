class City < ApplicationRecord
  validates_length_of :name, :maximum => 50, :allow_blank => false
    #It must make sense to avoid empty city names
end
