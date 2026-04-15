class Location < ApplicationRecord
  belongs_to :user
  has_many :cloths, dependent: :nullify

  validates :name, presence: true
end
