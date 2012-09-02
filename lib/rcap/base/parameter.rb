module RCAP
  module Base
    class Parameter
      include Validation

      validates_presence_of( :name, :value )

      # @return [String]
      attr_accessor( :name )
      # @return [String]
      attr_accessor( :value )

      XML_ELEMENT_NAME   = "parameter" 
      NAME_ELEMENT_NAME  = "valueName" 
      VALUE_ELEMENT_NAME = "value"     

      XPATH       = "cap:#{ XML_ELEMENT_NAME }"     
      NAME_XPATH  = "cap:#{ NAME_ELEMENT_NAME }"    
      VALUE_XPATH = "cap:#{ VALUE_ELEMENT_NAME }"   

      # @param [Hash] attributes
      # @option attributes [Symbol] :name Parameter name
      # @option attributes [Symbol] :value Parameter value
      def initialize
        yield( self ) if block_given?
      end

      # @return [REXML::Element]
      def to_xml_element 
        xml_element = REXML::Element.new( self.class::XML_ELEMENT_NAME )
        xml_element.add_element( self.class::NAME_ELEMENT_NAME ).add_text( @name )
        xml_element.add_element( self.class::VALUE_ELEMENT_NAME ).add_text( @value )
        xml_element
      end

      # @return [String]
      def to_xml 
        self.to_xml_element.to_s
      end

      # @return [String]
      def inspect 
        "#{ @name }: #{ @value }"
      end

      # Returns a string representation of the parameter of the form
      #  name: value
      #
      # @return [String]
      def to_s
        self.inspect
      end

      # Two parameters are equivalent if they have the same name and value.
      #
      # @param [Parameter] other
      # @return [true, false]
      def ==( other )
        [ @name, @value ] == [ other.name, other.value ]
      end

      # @return [Hash]
      def to_h 
        RCAP.attribute_values_to_hash( [ @name, @value ])
      end

      # @param [Hash] hash
      # @return [Parameter]
      def self.from_h( hash ) 
        key = hash.keys.first
        self.new do |parameter|
          parameter.name = key
          parameter.value = hash[ key ]
        end
      end
    end
  end
end

