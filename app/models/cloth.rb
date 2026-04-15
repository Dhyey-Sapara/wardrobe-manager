CLOTH_TYPE = %w[tshirt
                shirt
                pant
                overshirt
                sweatshirt
                hoodie
                jacket
                blazer
                kurta
                shoes
                other]

class Cloth < ApplicationRecord
  belongs_to :user
  belongs_to :location, optional: true

  has_one_attached :image
  after_commit :compress_image, on: [ :create, :update ]

  enum :cloth_type, CLOTH_TYPE.each_with_index.to_h { |type, i| [ type, i ] }, prefix: true

  validates :name, presence: true

  scope :by_color, ->(color) { where(color: color) if color.present? }
  scope :search, ->(query) { where("name ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%") if query.present? }

  private

  def compress_image
    return unless image.attached? && image.attachment.previously_new_record?
    return unless image.blob.content_type&.start_with?("image/")

    image.blob.open do |tempfile|
      compressed = ImageProcessing::MiniMagick
        .source(tempfile)
        .resize_to_limit(1200, 1200)
        .saver(quality: 50)
        .call

      image.blob.upload(compressed)
      compressed.close!
    end
  end
end
