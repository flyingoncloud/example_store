class Problem < ApplicationRecord
  # has_many :images
  has_many :answers
  attr_accessor  :answers_count, :images, :old_answer_index_id_maps, :deleted_old_answer_ids
  validates :problem_text, presence: true

  def self.latest
    Problem.order(:updated_at).last
  end

  def normalized_ids (image_ids)
    normalized_ids = image_ids
    if normalized_ids and normalized_ids.length > 0
      if normalized_ids.include?'[' then
        from = normalized_ids.index("[");
        to = normalized_ids.index("]");
        Rails.logger.debug("***Answer.normalized_ids: #{from}, #{to}")

        normalized_ids = normalized_ids[from + 1, to - 1]
        Rails.logger.debug("***Answer.image_ids: #{normalized_ids}")
      end
    end
    normalized_ids

  end

  def find_images
    if image_ids and image_ids.length > 0 then
      ids = normalized_ids(image_ids)
      @images = Image.find(ids.split(",").map{ |id| id.to_i })  #where("id in ?", image_ids)
      Rails.logger.debug("Found images: #{@images}")
    end

    @images
  end

  def image_urls
    image_urls = []
    @images = find_images
    if @images
      @images.each do |image|
        image_urls.push(image.image_url.to_s)
      end
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
