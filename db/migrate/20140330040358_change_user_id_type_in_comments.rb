class ChangeUserIdTypeInComments < ActiveRecord::Migration
  def up
    change_column :comments, :user_id, :integer
  end

  def down
    change_column :comments, :user_id, :string
  end
end
