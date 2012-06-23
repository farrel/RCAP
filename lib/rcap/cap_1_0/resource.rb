module RCAP
  module CAP_1_0

    # A Resource object is valid if
    # * it has a resource description
    class Resource < RCAP::Base::Resource
      
      # @param [REXML::Element] resource_xml_element
      # @return [Resource]
      def self.from_xml_element( resource_xml_element ) 
        resource = self.new( :resource_desc => RCAP.xpath_text( resource_xml_element, RESOURCE_DESC_XPATH, Alert::XMLNS ),
                             :uri           => RCAP.xpath_text( resource_xml_element, URI_XPATH, Alert::XMLNS ),
                             :mime_type     => RCAP.xpath_text( resource_xml_element, MIME_TYPE_XPATH, Alert::XMLNS ),
                             :size          => RCAP.xpath_text( resource_xml_element, SIZE_XPATH, Alert::XMLNS ).to_i,
                             :digest        => RCAP.xpath_text( resource_xml_element, DIGEST_XPATH, Alert::XMLNS ))
      end
    end
  end
end
