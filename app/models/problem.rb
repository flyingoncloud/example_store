class Problem < ApplicationRecord
  # has_many :image
  # has_many :answer
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

  def validate_image_urls

  end
end
