class Problem < ApplicationRecord
  has_many :images
  has_many :answers
  # attr_accessor  :normalized_problem_text
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

  def normalized_problem_text
    normalized_answer_text = normalized_html(problem_text)
  end

  def normalized_answers
    normalized_answers = []
    answers.each do |answer|
      normalized_answers.push(normalized_html(answer.answer_text))
    end
    normalized_answers
  end


  def normalized_html(problem_text)

    charCodeMap = { 60.chr => "&lt;", 62.chr => "&gt;", 10.chr  => "<br/>", 13.chr => "<br/>"}  #, 60.chr => "&lt;", 62.chr => "&gt;"
    charCodeMap.each do |key, value|
      problem_text = problem_text.gsub(key, value)
      # Rails.logger.debug("******: #{key}->#{value}, #{problem_text}")
    end
    problem_text
  end

  def validate_image_urls

  end
end
