class RenameTagAlias < ActiveRecord::Migration[5.0]
  def change
    rename_column :tags, :alias, :alias_text
  end
end
