ALLOWED_CHARACTERS = /[^\s&<]+/ # :nodoc:

module RCAP # :nodoc:
  def self.generate_identifier
    UUIDTools::UUID.random_create.to_s
  end

  def self.xpath_text( xml_element, xpath, namespace )
    element = self.xpath_first( xml_element, xpath, namespace )
    element.text if element
  end

  def self.xpath_first( xml_element, xpath, namespace )
    REXML::XPath.first( xml_element, xpath, { 'cap' => namespace })
  end

  def self.xpath_match( xml_element, xpath, namespace )
    REXML::XPath.match( xml_element, xpath, { 'cap' => namespace })
  end

  def self.format_lines_for_inspect( header, inspect_string )
    max_line_length = inspect_string.lines.map{ |line| line.chomp.length }.max
    "\n." + '-' * (max_line_length + 2) + ".\n"+
      '| ' + header.ljust( max_line_length ) + " |\n"+
      '|' + '-' * ( max_line_length + 2 ) + "|\n"+
      inspect_string.lines.map{ |line| '| ' + line.chomp.ljust( max_line_length ) +' |'}.join( "\n" ) + "\n" +
      "'" + '-' * ( max_line_length + 2 ) + "'\n"
  end

  def self.attribute_values_to_hash( *attribute_values )
    Hash[ *attribute_values.reject{ |key, value| value.nil? || ( value.respond_to?( :'empty?' ) && value.empty? )}.flatten( 1 )]
  end

  def self.to_s_for_cap( object )
    if object
      if object.respond_to?( :to_s_for_cap )
        object.to_s_for_cap
      else
        object.to_s
      end
    end
  end

  def self.parse_datetime( date_string )
    if date_string.is_a?( String )
      DateTime.parse( date_string )
    end
  end
end
