ALLOWED_CHARACTERS = /[^\s&<]+/

module RCAP
  # Returns a randomly generated UUID string
  #
  # @return [String] UUID string
  def self.generate_identifier
    UUIDTools::UUID.random_create.to_s
  end

  # Returns the text of the first descendent that matches the given XPath
  # expression.
  #
  # @param [REXML::Element] xml_element Element to start matching from.
  # @param [String] xpath XPath expression
  # @param [String] namespace Namespace in which to do the matching
  # @return [String,nil] Text content of element matching XPath query or nil
  def self.xpath_text( xml_element, xpath, namespace )
    element = self.xpath_first( xml_element, xpath, namespace )
    element.text if element
  end

  # Returns first descendent that matches the given XPath expression.
  #
  # @param [REXML::Element] xml_element Element to start matching from.
  # @param [String] xpath XPath expression
  # @param [String] namespace Namespace in which to do the matching
  # @return [REXML::Element,nil] Element matching XPath query or nil
  def self.xpath_first( xml_element, xpath, namespace )
    REXML::XPath.first( xml_element, xpath, { 'cap' => namespace })
  end

  # Returns all descendents that match the given XPath expression.
  #
  # @param [REXML::Element] xml_element Element to start matching from.
  # @param [String] xpath XPath expression
  # @param [String] namespace Namespace in which to do the matching
  # @return [Array<REXML::Element>] Collection of elements matching XPath query
  def self.xpath_match( xml_element, xpath, namespace )
    REXML::XPath.match( xml_element, xpath, { 'cap' => namespace })
  end

  # Formats output for inspect
  #
  # @param [String] header Output header
  # @param [String] inspect_string String to be output
  # @return [String] Formatted output for inspect
  #
  # @example
  #  RCAP.format_lines_for_inspect( 'Test', 'one\ntwo\nthree' )
  #  # returns
  #  # .-------.
  #  # | Test  |
  #  # |-------|
  #  # | one   |
  #  # | two   |
  #  # | three |
  #  # '-------'
  def self.format_lines_for_inspect( header, inspect_string )
    max_line_length = inspect_string.lines.map{ |line| line.chomp.length }.max
    "\n." + '-' * (max_line_length + 2) + ".\n"+
      '| ' + header.ljust( max_line_length ) + " |\n"+
      '|' + '-' * ( max_line_length + 2 ) + "|\n"+
      inspect_string.lines.map{ |line| '| ' + line.chomp.ljust( max_line_length ) +' |'}.join( "\n" ) + "\n" +
      "'" + '-' * ( max_line_length + 2 ) + "'\n"
  end

  # Converts an array of key value pairs into a hash, excluding any value that is nil.
  #
  # @param [Array<Array(Object,Object)>] attribute_values An array of arrays of key/value pairs
  # @return [Hash] Hash of attributes
  #
  # @example
  #  RCAP.attribute_values_to_hash( ['a', 1], ['b' , nil ]) # => { 'a' => 1 }
  def self.attribute_values_to_hash( *attribute_values )
    Hash[ *attribute_values.reject{ |key, value| value.nil? }.flatten( 1 )]
  end

  # Calls #to_s_for_cap on the object it it responds to that otherwise just calls #to_s
  #
  # @param [#to_s, #to_s_for_cap] object
  # @return [String]
  def self.to_s_for_cap( object )
    if object
      if object.respond_to?( :to_s_for_cap )
        object.to_s_for_cap
      else
        object.to_s
      end
    end
  end

  # If the parameter is a string the datetime is parsed out of it, otherwise returns nil.
  #
  # @param [String] date_string String to parse
  # @return [String,nil]
  def self.parse_datetime( date_string )
    if date_string.is_a?( String )
      DateTime.parse( date_string )
    end
  end
end
