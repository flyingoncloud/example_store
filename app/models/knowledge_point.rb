class KnowledgePoint < ApplicationRecord
  attr_accessor  :firstLevelKP, :firstLevelKPSet, :secondLevelParent, :secondLevelKPSet, :thirdLevelGrandParent, :thirdLevelParent, :thirdLevelKPSet

  # before_destroy :ensure_not_referenced_by_any_knowledge_point

  validates :name, :parent_id, :level, presence: true
  validates :name, uniqueness: true

  def self.all_children(parent_id = -1)
     KnowledgePoint.where("parent_id = ?", parent_id)
  end

  def self.latest
    KnowledgePoint.order(:updated_at).last
  end

  private

  def ensure_not_referenced_by_any_knowledge_point
    if !knowledge_points.empty?
      knowledge_points.each do |kp|
        if kp.knowledge_point_id != knowledge_point_id then
          errors.add(:base, 'has child knowledge point linked.')
          return false
        end
      end
      return true
    end
  end
end
