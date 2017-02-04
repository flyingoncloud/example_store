class Tag < ApplicationRecord
  attr_accessor  :tag_indexes, :parent_level

  # before_destroy :ensure_not_referenced_by_any_knowledge_point

  validates :name, :level, presence: true
  validates :name, uniqueness: true

  def self.all_children(parent_id = -1)
     Tag.where("parent_id = ?", parent_id)
  end

  def self.latest
    Tag.order(:updated_at).last
  end

  def normalized_alias_text
    normalized_alias_text = normalized_html(alias_text)
  end


  private

  def normalized_html(alias_text)
    charCodeMap = { 60.chr => "&lt;", 62.chr => "&gt;", 10.chr  => "<br/>", 13.chr => "<br/>"}  #, 60.chr => "&lt;", 62.chr => "&gt;"
    charCodeMap.each do |key, value|
      alias_text = alias_text.gsub(key, value)
      # Rails.logger.debug("******: #{key}->#{value}, #{alias_text}")
    end
    alias_text
  end

end
