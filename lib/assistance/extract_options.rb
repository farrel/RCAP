# Array extensions
class Array
  # Removes and returns the last member of the array if it is a hash. Otherwise,
  # an empty hash is returned This method is useful when writing methods that
  # take an options hash as the last parameter. For example:
  #
  #   def validate_each(*args, &block)
  #     opts = args.extract_options!
  #     ...
  #   end
  def extract_options!
    last.is_a?(Hash) ? pop : {}
  end
end
