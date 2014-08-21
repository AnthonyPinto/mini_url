class RenameVisitUserIdColumn < ActiveRecord::Migration
  def change
    rename_column(:visits, :users_id, :user_id)
  end
end
