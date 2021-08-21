class CreateCategory < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.references :parent, foreign_key: { to_table: :categories }, null: true

      t.string :name, index: true, null: false
    end
  end
end
