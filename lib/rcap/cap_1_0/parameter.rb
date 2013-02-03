module RCAP
  module CAP_1_0
    # A Parameter object is valid if
    # * it has a name
    # * it has a value
    class Parameter < RCAP::Base::Parameter

      # @return [REXML::Element]
      def to_xml_element
        xml_element = REXML::Element.new( self.class::XML_ELEMENT_NAME )
        xml_element.add_text( "#{ @name }=#{ @value }")
        xml_element
      end

      # @param [REXML::Element] parameter_xml_element
      # @return [Parameter]
      def self.from_xml_element( parameter_xml_element )
        parameter_hash = self.parse_parameter( parameter_xml_element.text )
        self.new do |parameter|
          parameter.name   = RCAP.strip_if_given( parameter_hash[ :name ])
          parameter.value  = RCAP.strip_if_given( parameter_hash[ :value ])
        end
      end

      # @param [String] parameter_string
      # @return [Hash]
      def self.parse_parameter( parameter_string )
        name, value = parameter_string.split("=")
        if name && value
          { :name  => RCAP.strip_if_given( name ),
            :value => RCAP.strip_if_given( value )}
        end
      end
    end
  end
end
