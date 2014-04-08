class ChangeTextToBody < ActiveRecord::Migration
  def change
    rename_column :emails, :text, :body
  end
end
