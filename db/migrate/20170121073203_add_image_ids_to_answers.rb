class AddImageIdsToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :image_ids, :string
    remove_column :answers, :problem_idd
    remove_column :answers, :answer_id
  end
end
