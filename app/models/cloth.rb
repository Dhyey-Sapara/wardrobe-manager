class Cloth < ApplicationRecord
  has_one_attached :image

  enum :cloth_type, { tshirt: 0, shirt: 1, pant: 2, overshirt: 3, jacket: 4, kurta: 5, shoes: 6, other: 7 }, prefix: true
  enum :location, { surat: 0, indore: 1 }, prefix: true

  validates :name, presence: true

  scope :by_color, ->(color) { where(color: color) if color.present? }
  scope :search, ->(query) { where("name ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%") if query.present? }
end
