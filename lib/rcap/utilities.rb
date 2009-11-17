ALLOWED_CHARACTERS = /[^\s&<]+/ # :nodoc:

class Array # :nodoc:
  def to_s_for_cap
    self.map{ |element| element.to_s.for_cap_list }.join( ' ' )
  end
end

class String # :nodoc:
  CAP_LIST_REGEX = /"([\w\s]+)"|(\S+)/
  WHITESPACE_REGEX = /^\s+$/ 

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
	RCAP_ZONE_FORMAT = "%+02i:00"

	def to_s_for_cap
	  self.strftime( RCAP_TIME_FORMAT ) + format( RCAP_ZONE_FORMAT , self.utc_hours_offset ) 
  end
end

module RCAP # :nodoc:
	def self.xpath_text( xml_element, xpath ) 
		element = self.xpath_first( xml_element, xpath )
		element.text if element
	end

	def self.xpath_first( xml_element, xpath )
		REXML::XPath.first( xml_element, xpath, { 'cap' => RCAP::XMLNS })
	end

	def self.xpath_match( xml_element, xpath )
		REXML::XPath.match( xml_element, xpath, { 'cap' => RCAP::XMLNS })
	end

  def self.format_lines_for_inspect( header, inspect_string )
    max_line_length = inspect_string.lines.inject( 0 ){ |max_length, line| line.chomp.length > max_length ? line.chomp.length : max_length }
    "\n." + '-' * max_line_length + ".\n"+
    '|' + header.ljust( max_line_length ) + "|\n"+
    '|' + '-' * max_line_length + "|\n"+
    inspect_string.lines.map{ |line| '|' + line.chomp.ljust( max_line_length ) +'|'}.join( "\n" ) + "\n" +
    "'" + '-' * max_line_length + "'\n"
  end
end
