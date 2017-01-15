class Image < ApplicationRecord

  belongs_to :problem

  validates :image_url, presence: true

  validates :image_url, allow_blank: false, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'The URL must point to an image format GIF, JPG, PNG.'
  }

  def self.latest
    Image.order(:updated_at).last
  end

end
