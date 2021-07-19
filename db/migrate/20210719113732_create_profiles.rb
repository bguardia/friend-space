class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.references :user
      t.string  :firstname
      t.string :lastname
      t.text :bio
      t.date :birthday
      t.timestamps
    end
  end
end
