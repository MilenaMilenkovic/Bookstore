class BookInteractor < Interactor
  permitted_keys  %i[category_id title author short_description cover_image]
  display_keys    %i[id title author short_description cover_image_url category]

  def category
    CategoryDecorator.new(subject.category)
  end
end
