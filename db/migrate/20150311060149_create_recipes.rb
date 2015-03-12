class CreateRecipes < ActiveRecord::Migration
  def change
  	drop_table :recipes
    create_table :recipes do |t|
      t.string :name
      t.text :instructions

      t.timestamps null: false
    end
  end
end
