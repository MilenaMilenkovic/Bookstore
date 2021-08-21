# Module used to wrap the object with read/write properties
module InteractorConcern
  extend ActiveSupport::Concern

  PAGE_SIZE = 50

  protected

  def interactor
    @interactor ||= interactor_class.new(wrapped_object) if wrapped_object
  end

  def interactor_class
    @interactor_class ||= "#{wrapped_class.name}Interactor".constantize
  end

  def interactor_list
    @interactor_list ||= _interact_list(wrapped_list)
  end

  def new_object
    @wrapped_object ||= wrapped_class.new(permitted_params)
  end

  def wrapped_object
    @wrapped_object ||= wrapped_class.find_by(identifier)
  end

  def wrapped_class
    @wrapped_class ||= self.class.name.demodulize.remove(/Controller/).singularize.constantize
  end

  def wrapped_list
    @wrapped_list ||= wrapped_class.all
  end

  def paginated_interactor_list
    offset = params[:page].to_i&.*(PAGE_SIZE)

    _interact_list(wrapped_list.offset(offset).limit(PAGE_SIZE))
  end

  # Identifier for a wrapped object
  # If we want to use encoded id, then just this method needs to be updated
  # i.e. params[:id] should be decoded on this place
  def identifier
    @identifier ||= { id: params[:id] }
  end

  def permitted_params
    params.permit(interactor_class.permitted_keys)
  end

  private

    def _interact_list(list)
      list.collect do |wrapped_object|
        interactor_class.new(wrapped_object)
      end
    end
end
