class UpdateProblems < ActiveRecord::Migration[5.0]
  def change
    change_table :problems do |t|
      t.string :normalized_problem_text
    end
  end
end
