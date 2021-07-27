class CreateFriendships < ActiveRecord::Migration[6.1]
  def change
    create_table :friendships do |t|
      t.belongs_to :user
      t.belongs_to :friend, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
