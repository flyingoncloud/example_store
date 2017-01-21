class Answer < ApplicationRecord
  # has_many :images
  belongs_to :problem
  validates :answer_text, presence: true

  def find_images
    if image_ids then
      @images = Image.find(image_ids.split(",").map{ |id| id.to_i })  #where("id in ?", image_ids)
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
    if image_ids then
      @images = Image.where("id in ?", image_ids )
      Rails.logger.debug("Found images: #{@images}")
    end

    @images
  end

end
