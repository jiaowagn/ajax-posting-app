class CreatePostScores < ActiveRecord::Migration[5.2]
  def change
    create_table :post_scores do |t|
      t.integer :post_id, :index => true
      t.integer :user_id
      t.integer :score
      
      t.timestamps
    end
  end
end
