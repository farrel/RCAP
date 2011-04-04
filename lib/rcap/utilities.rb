ALLOWED_CHARACTERS = /[^\s&<]+/ # :nodoc:

  class Array # :nodoc:
    def to_s_for_cap
      self.map{ |element| element.to_s.for_cap_list }.join( ' ' )
    end
  end

class String # :nodoc:
  CAP_LIST_REGEX = Regexp.new( '"([\w\s]+)"|(\S+)' )
  WHITESPACE_REGEX = Regexp.new('^\s+$')

  def for_cap_list
    if self =~ /\s/
      '"'+self+'"'
    else
      self
    end
  end

  def unpack_cap_list
    self.split( CAP_LIST_REGEX ).reject{ |match| match == "" || match =~ WHITESPACE_REGEX }
  end
end

class DateTime # :nodoc:
  alias inspect to_s
  alias to_s_for_cap to_s
end

class Time # :nodoc:
  RCAP_TIME_FORMAT = "%Y-%m-%dT%H:%M:%S"
  RCAP_ZONE_FORMAT = "%+03i:00"

  def to_s_for_cap
    t = self.strftime( RCAP_TIME_FORMAT ) + format( RCAP_ZONE_FORMAT , self.utc_hours_offset )
    t.sub(/\+(00:\d\d)$/, '-\1')
  end

  def utc_hours_offset
    self.utc_offset/3600
  end
end

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
    max_line_length = inspect_string.lines.inject( 0 ){ |max_length, line| line.chomp.length > max_length ? line.chomp.length : max_length }
    "\n." + '-' * max_line_length + ".\n"+
      '|' + header.ljust( max_line_length ) + "|\n"+
      '|' + '-' * max_line_length + "|\n"+
      inspect_string.lines.map{ |line| '|' + line.chomp.ljust( max_line_length ) +'|'}.join( "\n" ) + "\n" +
      "'" + '-' * max_line_length + "'\n"
  end

  def self.attribute_values_to_hash( *attribute_values )
    Hash[ *attribute_values.reject{ |key, value| value.nil? || ( value.respond_to?( :'emtpy?' ) && value.empty? )}.flatten( 1 )]
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
