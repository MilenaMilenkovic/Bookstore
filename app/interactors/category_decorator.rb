class CategoryDecorator < Decorator
  display_keys %i[name parent parents]

  def parent
    subject.parent&.slice(:id, :name)
  end

  def parents
    _parents(subject.parent)
  end

  private

    def _parents(category, hierarhy_list = [])
      return [] if category.nil?
      return category.name if category.parent.nil?

      hierarhy_list + [category.name, *_parents(category.parent)]
    end
end
