class CategoryBooksQuery < Query

  def initialize(relation = Book)
    @relation = relation
  end

  def call(category)
    categories = Category.where(name: category)

    if categories.exists?
      Book.where(category_id: hierarhy_of(categories))
    else
      Book.none
    end
  end

  private

    def hierarhy_of(categories)
      CategoryHierarhyQuery.new(categories).call.pluck(:id)
    end
end
