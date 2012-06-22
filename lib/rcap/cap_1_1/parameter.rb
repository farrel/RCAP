module RCAP
  module CAP_1_1

    # A Parameter object is valid if
    # * it has a name
    # * it has a value
    class Parameter < RCAP::Base::Parameter

      # @param [REXML::Element] parameter_xml_element
      # @return [Parameter] 
      def self.from_xml_element( parameter_xml_element ) # :nodoc:
        self.new( :name  => RCAP.xpath_text( parameter_xml_element, self::NAME_XPATH, Alert::XMLNS ),
                  :value => RCAP.xpath_text( parameter_xml_element, self::VALUE_XPATH, Alert::XMLNS ))
      end
    end
  end
end
