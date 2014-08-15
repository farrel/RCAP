class Array
  # Formats an array into a string suitable for a CAP message.
  #
  # @return [String]
  # @example
  #   [ "one", "two words", "three" ].to_s_for_cap # => "one \"two words\" three"
  # @see String#unpack_cap_list
  def to_s_for_cap
    map { |element| element.to_s.for_cap_list }.join(' ')
  end

  def blank?
    empty?
  end

  def extract_options!
    last.is_a?(Hash) ? pop : {}
  end
end
