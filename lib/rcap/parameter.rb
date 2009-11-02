module CAP
	class Parameter
		include Validation

		validates_presence_of( :name, :value )

		attr_accessor( :name, :value )

		XML_ELEMENT_NAME   = "parameter" # :nodoc:
		NAME_ELEMENT_NAME  = "valueName" # :nodoc:
		VALUE_ELEMENT_NAME = "value"     # :nodoc:

		XPATH       = "cap:#{ XML_ELEMENT_NAME }"     # :nodoc:
		NAME_XPATH  = "cap:#{ NAME_ELEMENT_NAME }"    # :nodoc:
		VALUE_XPATH = "cap:#{ VALUE_ELEMENT_NAME }"   # :nodoc:

		def initialize( attributes = {} )
			@name = attributes[ :name ]
			@value = attributes[ :value ] 
		end

		def to_xml_element
			xml_element = REXML::Element.new( XML_ELEMENT_NAME )
			xml_element.add_element( NAME_ELEMENT_NAME ).add_text( self.name )
			xml_element.add_element( VALUE_ELEMENT_NAME ).add_text( self.value )
			xml_element
		end

		def to_xml
			self.to_xml_element.to_s
		end

    def inspect
      "#{ self.name }: #{ self.value }"
    end

    def to_s
      self.inspect
		end

		def self.from_xml_element( parameter_xml_element )
			Parameter.new( :name  => CAP.xpath_text( parameter_xml_element, NAME_XPATH ),
										 :value => CAP.xpath_text( parameter_xml_element, VALUE_XPATH ))
		end

		def ==( other )
			[ self.name, self.value ] == [ other.name, other.value ]
		end
	end
end
