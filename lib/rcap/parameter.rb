module CAP
	class Parameter
		include Validation
		NAME = :name
		VALUE = :value
		ATOMIC_ATTRIBUTES = [ NAME, VALUE ]

		validates_presence_of( *ATOMIC_ATTRIBUTES )

		attr_accessor( *ATOMIC_ATTRIBUTES )

		XML_ELEMENT_NAME = "parameter"
		NAME_ELEMENT_NAME = "valueName"
		VALUE_ELEMENT_NAME = "value"

		def initialize( attributes = {} )
			@name = attributes[ NAME ]
			@value = attributes[ VALUE ] 
		end

		def to_xml_element
			xml_element = REXML::Element.new( XML_ELEMENT_NAME )
			xml_element.add_element( NAME_ELEMENT_NAME ).add_text( @name )
			xml_element.add_element( VALUE_ELEMENT_NAME ).add_text( @value )
			xml_element
		end

		def to_xml
			self.to_xml_element.to_s
		end
	end
end
