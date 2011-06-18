module RCAP
  module CAP_1_0
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
        xml_element = REXML::Element.new( self.class::XML_ELEMENT_NAME )
        xml_element.add_text( "#{ self.name }=#{ self.value }")
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
        self.new( self.parse_parameter( parameter_xml_element.text ))
      end

      # Two parameters are equivalent if they have the same name and value.
      def ==( other )
        [ self.name, self.value ] == [ other.name, other.value ]
      end

      def to_h # :nodoc:
        RCAP.attribute_values_to_hash( [ self.name, self.value ])
      end

      def self.from_h( hash ) # :nodoc:
        key = hash.keys.first
        self.new( :name => key, :value => hash[ key ])
      end

      def self.parse_parameter( parameter_string ) # :nodoc:
        name, value = parameter_string.split("=")
        { :name  => name,
          :value => value }
      end
    end
  end
end
