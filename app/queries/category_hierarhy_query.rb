class CategoryHierarhyQuery < Query

  def initialize(relation = Category)
    # Relation with parent categories
    @relation = relation
  end

  def call
    @relation.or(subcategories)
  end

  private

    def subcategories
      Category.where("id IN (#{hierarhy_sql})")
    end

    # As the app should support SQL version 5.7+, the query is defined by using variables
    # More efficient way would be to use recursive CTE (supported by MySql 8+)
    def hierarhy_sql
      @relation.pluck(:id).map {|id| children_hierarhy(id) }.join(") UNION (")
    end

    def children_hierarhy(child_id)
      <<~SQL
          select categories.id
          from categories,
               (select @parent := #{child_id.to_i}) vars
          where find_in_set(categories.parent_id, @parent) > 0 and @parent := concat(@parent, ',', categories.id)
      SQL
    end

end
