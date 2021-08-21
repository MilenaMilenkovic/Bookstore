class CreateBooks < ActiveRecord::Migration[6.0]
  def up
    create_table :books do |t|
      t.references :category
      t.string     :title
      t.string     :author
      t.text       :cover_image_data
      # Limit is 255, so :string can be used
      t.string     :short_description

      t.timestamps
    end

    execute 'CREATE FULLTEXT INDEX ft_index_books_on_title ON books(title)'
    execute 'CREATE FULLTEXT INDEX ft_index_books_on_author ON books(author)'
  end

  def down
    drop_table :books
  end
end
