module RCAP
  module CAP_1_0

    # In Info object is valid if
    # * it has an event
    # * it has an urgency with a valid value
    # * it has a severity with a valid value
    # * it has a certainty with a valid value
    # * all categories are valid and categories has at minimum 1 entry
    # * all Resource objects in the resources collection are valid
    # * all Area objects in the areas collection are valid
    class Info < RCAP::Base::Info

      validates_inclusion_of( :certainty, :allow_nil => true, :in => VALID_CERTAINTIES, :message => "can only be assigned the following values: #{ VALID_CERTAINTIES.join(', ') }")


      def event_code_class
        EventCode
      end

      def parameter_class
        Parameter
      end

      def resource_class
        Resource
      end

      def area_class
        Area
      end

      # @param [REXML::Element] info_xml_element
      # @return [Info]
      def self.from_xml_element( info_xml_element ) 
        self.new do |info|
          info.language       = RCAP.xpath_text( info_xml_element, LANGUAGE_XPATH, Alert::XMLNS ) || DEFAULT_LANGUAGE

          RCAP.xpath_match( info_xml_element, CATEGORY_XPATH, Alert::XMLNS ).each do |element|
            info.categories << element.text 
          end

          info.event          = RCAP.xpath_text( info_xml_element, EVENT_XPATH, Alert::XMLNS )
          info.urgency        = RCAP.xpath_text( info_xml_element, URGENCY_XPATH, Alert::XMLNS )
          info.severity       = RCAP.xpath_text( info_xml_element, SEVERITY_XPATH, Alert::XMLNS )
          info.certainty      = RCAP.xpath_text( info_xml_element, CERTAINTY_XPATH, Alert::XMLNS )
          info.audience       = RCAP.xpath_text( info_xml_element, AUDIENCE_XPATH, Alert::XMLNS )
          info.effective      = (( effective = RCAP.xpath_first( info_xml_element, EFFECTIVE_XPATH, Alert::XMLNS )) ? DateTime.parse( effective.text ) : nil )
          info.onset          = (( onset = RCAP.xpath_first( info_xml_element, ONSET_XPATH, Alert::XMLNS )) ? DateTime.parse( onset.text ) : nil )
          info.expires        = (( expires = RCAP.xpath_first( info_xml_element, EXPIRES_XPATH, Alert::XMLNS )) ? DateTime.parse( expires.text ) : nil )
          info.sender_name    = RCAP.xpath_text( info_xml_element, SENDER_NAME_XPATH, Alert::XMLNS )
          info.headline       = RCAP.xpath_text( info_xml_element, HEADLINE_XPATH, Alert::XMLNS )
          info.description    = RCAP.xpath_text( info_xml_element, DESCRIPTION_XPATH, Alert::XMLNS )
          info.instruction    = RCAP.xpath_text( info_xml_element, INSTRUCTION_XPATH, Alert::XMLNS )
          info.web            = RCAP.xpath_text( info_xml_element, WEB_XPATH, Alert::XMLNS )
          info.contact        = RCAP.xpath_text( info_xml_element, CONTACT_XPATH, Alert::XMLNS )

          RCAP.xpath_match( info_xml_element, EventCode::XPATH, Alert::XMLNS ).each do |element|
            info.event_codes << info.event_code_class.from_xml_element( element )
          end

          RCAP.xpath_match( info_xml_element, Parameter::XPATH, Alert::XMLNS ).each do |element|
            info.parameters <<  info.parameter_class.from_xml_element( element )
          end

          RCAP.xpath_match( info_xml_element, Resource::XPATH, Alert::XMLNS ).each do  |element|
           info.resources <<  info.resource_class.from_xml_element( element )
          end

          RCAP.xpath_match( info_xml_element, Area::XPATH, Alert::XMLNS ).each do |element|
            info.areas << info.area_class.from_xml_element( element )
          end
        end
      end
    end
  end
end
