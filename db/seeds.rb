# When running db:seed task, seeds will run in alphabetical order

module Seeds

  class << self
    def seed1_categories
      process_seedfile(:categories, Category) do |data|
        data.each do |book_data|
          parent = Category.find_by_name(book_data['parent']) unless book_data['parent'].nil?
          Category.find_or_create_by(name: book_data['name'], parent: parent)
        end
      end
    end

    def seed2_books
      process_seedfile(:books, Book) do |data|
        data.each do |book_data|
          category = Category.find_by_name(book_data['category'])
          Book.find_or_create_by(category: category, **book_data.except('category').symbolize_keys)
        end
      end
    end

    private

    def process_seedfile(filename, klass, &block)
      puts "Seeding #{klass.name}..."

      data = read_seedfile(filename)

      if block_given?
        yield(data)
      else
        # NOTE: Be avare that insert_all do not trigger callbacks or validations
        klass.insert_all(data)
      end

      puts 'Done.'
    end

    def read_seedfile(filename)
      seedfile = Rails.root.join('db', 'seeds', "#{filename}.yaml")

      unless seedfile.exist?
        puts 'Rails do not know how to run seed.'
        return
      end

      YAML.load(seedfile.read)
    end
  end
end
