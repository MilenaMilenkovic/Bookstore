class CategoryHierarhyQuery < Query

  def initialize(relation = Category)
    # Relation with parent categories
    @relation = relation
  end

  def call
    @relation.or(Category.where(id: subcategories.to_a.flatten))
  end

  private

    def subcategories
      Category.connection.execute <<~SQL
        #{parents_cte}
        SELECT * from #{parent_hierarhy_ctes.keys.join(' JOIN ')};
      SQL
    end

    def parents_cte
      <<~SQL
          WITH RECURSIVE
          #{parent_hierarhy_ctes.values.join(', ')}
      SQL
    end

    def parent_hierarhy_ctes
      @parent_hierarhy_ctes ||= @relation.pluck(:id).inject({}) do |h, id|
        h[cte_name(id)] = parent_hierarhy_cte(id)
        h
      end
    end

    def parent_hierarhy_cte(child_id)
      cte = cte_name(child_id)
      <<~SQL
          #{cte} AS
          (
            SELECT id from categories WHERE id = #{child_id.to_i}
            UNION ALL
            SELECT c.id FROM categories c JOIN #{cte}
            ON #{cte}.id=c.parent_id
          )
      SQL
    end

    def cte_name(id)
      "parents#{id.to_i}"
    end

end
