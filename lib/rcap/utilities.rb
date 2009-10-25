ALLOWED_CHARACTERS = /[^\s&<]+/

class Array
  def to_s_for_cap
    self.map{ |element| element.to_s.for_cap_list }.join( ' ' )
  end
end

class String
  def for_cap_list
    if self =~ /\s/
      '"'+self+'"'
    else
      self
    end
  end
end

class Time
  RCAP_TIME_FORMAT = "%Y-%m-%dT%H:%M:%S"
  RCAP_ZONE_FORMAT = "%+02i:00"
  def to_s_for_cap
    self.strftime( RCAP_TIME_FORMAT ) + format( RCAP_ZONE_FORMAT , self.utc_hours_offset )
  end

  def utc_hours_offset
    self.utc_offset/3600
  end
end

module CAP
	def self.xpath_text( xml_element, xpath )
		REXML::XPath.first( xml_element, xpath, { 'cap' => CAP::XMLNS }).text
	end

	def self.xpath_first( xml_element, xpath )
		REXML::XPath.first( xml_element, xpath, { 'cap' => CAP::XMLNS })
	end

	def self.xpath_match( xml_element, xpath )
		REXML::XPath.match( xml_element, xpath, { 'cap' => CAP::XMLNS })
	end
end
