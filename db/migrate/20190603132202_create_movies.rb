class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.text :summary, null: false
      t.integer :category_id

      t.timestamps
    end
  end
end
