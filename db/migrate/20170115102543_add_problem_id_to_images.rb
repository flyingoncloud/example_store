class AddProblemIdToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :problem_id, :integer
  end
end
