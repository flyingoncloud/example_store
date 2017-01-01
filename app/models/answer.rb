class Answer < ApplicationRecord
  belongs_to :problem
  validates :answer_text, presence: true
  

  def self.latest
    Problem.order(:updated_at).last
  end

end
