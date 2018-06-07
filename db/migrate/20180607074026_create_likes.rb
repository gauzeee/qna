class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.integer :rating, default: 0, null: false
      t.references :likable, polymorphic: true
      t.references :user

      t.timestamps
    end
  end
end
