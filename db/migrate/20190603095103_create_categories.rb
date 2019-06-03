class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name, null: false, limit: 100 # "soft" limit will be something like 70
      t.timestamps
    end
  end
end
