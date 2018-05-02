class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.integer :post_id, :index => true
      t.integer :user_id, :index => true

      t.timestamps
    end
  end
end
