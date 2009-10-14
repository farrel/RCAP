module CAP
  class EventCode < Parameter

    XML_ELEMENT_NAME = 'eventCode'

    def to_xml_element
      xml_element = REXML::Element.new( XML_ELEMENT_NAME )
      xml_element.add_element( NAME_ELEMENT_NAME ).add_text( self.name )
      xml_element.add_element( VALUE_ELEMENT_NAME ).add_text( self.value )
      xml_element
    end
  end
end
