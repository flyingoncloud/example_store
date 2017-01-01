class Image < ApplicationRecord

  # belongs_to :problem

  validates :image_url, presence: true

  validates :image_url, allow_blank: false, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'The URL must point to an image format GIF, JPG, PNG.'
  }

  def self.latest
    Image.order(:updated_at).last
  end

  def self.save(upload)
    name = upload.original_filename
    tempfile = upload.tempfile

    # create the file path
    imagePath = Rails.root.join('app/assets/images', 'uploads', name);

    # write the file
    File.open(imagePath, "wb") { |f| f.write(tempfile.read) }

    @image = Image.new()
    @image.image_url = name
    @image.save

    Rails.logger.debug("Saved image: #{@image.id}")

    @image

   end
end
