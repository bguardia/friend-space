class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.bigint :likeable_id
      t.string :likeable_type
      t.belongs_to :user
      t.timestamps
    end
  end
end
