# Class every presenter class should inherit from
class BasePresenter
  # Initialize class with object to be presented and the view it is to be presented on
  def initialize(object, template)
    @object = object
    @template = template
  end

  # Same as application helper short date
  def format_date(date)
    date.strftime("%Y-%m-%d")
  end

private
 # Class method to call the object by its class
  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  # Accessor for template methods
  def t
    @template
  end

  # In the event a method called can't be found, default to the template methods
  def method_missing(*args, &block)
    @template.send(*args, &block)
  end
end
