class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string :status
      t.string :type
      t.bigint :notifiable_id
      t.string :notifiable_type
      t.references :receiver, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
