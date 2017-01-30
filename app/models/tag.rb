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

  private

  
end
