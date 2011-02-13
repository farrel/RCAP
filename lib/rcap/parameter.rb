module RCAP
	# A Parameter object is valid if
	# * it has a name
	# * it has a value
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

		def to_xml_element # :nodoc:
			xml_element = REXML::Element.new( XML_ELEMENT_NAME )
			xml_element.add_element( NAME_ELEMENT_NAME ).add_text( self.name )
			xml_element.add_element( VALUE_ELEMENT_NAME ).add_text( self.value )
			xml_element
		end

		def to_xml # :nodoc:
			self.to_xml_element.to_s
		end

    def inspect # :nodoc:
			"#{ self.name }: #{ self.value }"
    end

		# Returns a string representation of the parameter of the form
		#  name: value
    def to_s
      self.inspect
		end

		def self.from_xml_element( parameter_xml_element ) # :nodoc:
			Parameter.new( :name  => RCAP.xpath_text( parameter_xml_element, NAME_XPATH ),
										 :value => RCAP.xpath_text( parameter_xml_element, VALUE_XPATH ))
		end

		# Two parameters are equivalent if they have the same name and value.
		def ==( other )
			[ self.name, self.value ] == [ other.name, other.value ]
		end

    def to_h
      { @name => @value }
    end

    def self.from_h( hash )
      self.new( :name => hash.keys.first, :value => hash.values.first ) 
    end
	end
end
