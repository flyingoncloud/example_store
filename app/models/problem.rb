class Problem < ApplicationRecord
  has_many :images
  has_many :answers
  attr_accessor  :normalized_problem_text
  validates :problem_text, presence: true
  # validates :validate_image_urls
  # image_urls, allow_blank: true, format: {
  #   with: %r{\.(gif|jpg|png)\Z}i,
  #   message: 'The URL must point to an image format GIF, JPG, PNG.'
  # }

  def self.latest
    Problem.order(:updated_at).last
  end

  def image_urls
    image_urls = []
    images.each do |image|
      image_urls.push(image.image_url.to_s)
    end
    image_urls
  end

  def validate_image_urls

  end
end
