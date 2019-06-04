class Discount < ApplicationRecord
  belongs_to :user
  
  validates_presence_of
end
