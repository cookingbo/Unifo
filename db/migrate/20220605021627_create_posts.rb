class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id,   null: false
      t.string :place,      null: false
      t.text :explaination, null: false

      t.timestamps
    end
  end
end
