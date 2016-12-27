class Problem < ApplicationRecord

  validates :problem_text, presence: true
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'The URL must point to an image format GIF, JPG, PNG.'
  }

  def self.latest
    Problem.order(:updated_at).last
  end

end
