ALLOWED_CHARACTERS = /[^\s&<]+/

class Array
  def to_s_for_cap
    self.map{ |element| element.to_s.for_cap_list }.join( ' ' )
  end
end

class String
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

class DateTime
	alias inspect to_s
end

module CAP
	def self.xpath_text( xml_element, xpath )
		element = self.xpath_first( xml_element, xpath )
		element.text if element
	end

	def self.xpath_first( xml_element, xpath )
		REXML::XPath.first( xml_element, xpath, { 'cap' => CAP::XMLNS })
	end

	def self.xpath_match( xml_element, xpath )
		REXML::XPath.match( xml_element, xpath, { 'cap' => CAP::XMLNS })
	end
end
