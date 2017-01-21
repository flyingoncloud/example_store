class Image < ApplicationRecord
  validates :image_url, presence: true

  validates :image_url, allow_blank: false, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'The URL must point to an image format GIF, JPG, PNG.'
  }

  def self.latest
    Image.order(:updated_at).last
  end

  def self.save_image_file?(uploaded_image)
    name = uploaded_image.original_filename
    tempfile = uploaded_image.tempfile
    begin
      # create the file path
      imagePath = Rails.root.join('app/assets/images', 'uploads', name);

      # write the file
      File.open(imagePath, "wb") { |f| f.write(tempfile.read) }
    rescue Exception => e
      Rails.logger.error("Cannot save images.", e)
      false
    end

    true
  end

  def self.save(uploaded_image)
    image = nil
    if save_image_file? (uploaded_image)
      image = Image.new()
      image.image_url = ApplicationHelper::UPLOAD_BASE_PATH + "/" + uploaded_image.original_filename
      image.save

      Rails.logger.debug("Saved image: #{image.id}")
    end

    image
  end

end
