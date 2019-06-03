class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.integer :user_id, null: false
      t.integer :movie_id, null: false
      t.integer :stars, default: 0
      t.timestamps
    end
  end
end
