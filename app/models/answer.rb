class Answer < ApplicationRecord
  # has_many :images
  belongs_to :problem
  validates :answer_text, presence: true

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
    Rails.logger.debug("Answer.image_ids: #{image_ids}")
    ids = normalized_ids (image_ids)
    if ids and ids.length > 0 then
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

  def self.latest
    Problem.order(:updated_at).last
  end

  def images
    if image_ids and image_ids.length > 0 then
      @images = Image.where("id in ?", image_ids )
      Rails.logger.debug("Found images: #{@images}")
    end

    @images
  end

end
