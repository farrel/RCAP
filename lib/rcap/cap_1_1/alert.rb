module RCAP
  module CAP_1_1

    # An Alert object is valid if
    # * it has an identifier
    # * it has a sender
    # * it has a sent time
    # * it has a valid status value
    # * it has a valid messge type value
    # * it has a valid scope value
    # * all Info objects contained in infos are valid
    class Alert < RCAP::Base::Alert

      XMLNS = "urn:oasis:names:tc:emergency:cap:1.1"
      CAP_VERSION = "1.1"

      STATUS_DRAFT    = "Draft"    
      # Valid values for status
      VALID_STATUSES = [ STATUS_ACTUAL, STATUS_EXERCISE, STATUS_SYSTEM, STATUS_TEST, STATUS_DRAFT ]

      def info_class
        Info
      end

      # @param [REXML::Element] alert_xml_element
      # @return [Alert]
      def self.from_xml_element( alert_xml_element ) 
        self.new( :identifier  => RCAP.xpath_text( alert_xml_element, IDENTIFIER_XPATH, Alert::XMLNS ),
                  :sender      => RCAP.xpath_text( alert_xml_element, SENDER_XPATH, Alert::XMLNS ),
                  :sent        => (( sent = RCAP.xpath_first( alert_xml_element, SENT_XPATH, Alert::XMLNS )) ? DateTime.parse( sent.text ) : nil ),
                  :status      => RCAP.xpath_text( alert_xml_element, STATUS_XPATH, Alert::XMLNS ),
                  :msg_type    => RCAP.xpath_text( alert_xml_element, MSG_TYPE_XPATH, Alert::XMLNS ),
                  :source      => RCAP.xpath_text( alert_xml_element, SOURCE_XPATH, Alert::XMLNS ),
                  :scope       => RCAP.xpath_text( alert_xml_element, SCOPE_XPATH, Alert::XMLNS ),
                  :restriction => RCAP.xpath_text( alert_xml_element, RESTRICTION_XPATH, Alert::XMLNS ),
                  :addresses   => (( address = RCAP.xpath_text( alert_xml_element, ADDRESSES_XPATH, Alert::XMLNS )) ? address.unpack_cap_list : nil ),
                  :codes       => RCAP.xpath_match( alert_xml_element, CODE_XPATH, Alert::XMLNS ).map{ |element| element.text },
                  :note        => RCAP.xpath_text( alert_xml_element, NOTE_XPATH, Alert::XMLNS ),
                  :references  => (( references = RCAP.xpath_text( alert_xml_element, REFERENCES_XPATH, Alert::XMLNS )) ? references.split( ' ' ) : nil ),
                  :incidents   => (( incidents = RCAP.xpath_text( alert_xml_element, INCIDENTS_XPATH, Alert::XMLNS )) ? incidents.split( ' ' ) : nil ),
                  :infos       => RCAP.xpath_match( alert_xml_element, Info::XPATH, Alert::XMLNS ).map{ |element| Info.from_xml_element( element )})
      end

      # @param [Hash] alert_yaml_data
      # @return [Alert]
      def self.from_yaml_data( alert_yaml_data ) 
        Alert.new( :identifier  => alert_yaml_data[ IDENTIFIER_YAML ],
                   :sender      => alert_yaml_data[ SENDER_YAML ],
                   :sent        => ( sent = alert_yaml_data[ SENT_YAML ]).blank? ? nil : DateTime.parse( sent.to_s ),
                   :status      => alert_yaml_data[ STATUS_YAML ],
                   :msg_type    => alert_yaml_data[ MSG_TYPE_YAML ],
                   :source      => alert_yaml_data[ SOURCE_YAML ],
                   :scope       => alert_yaml_data[ SCOPE_YAML ],
                   :restriction => alert_yaml_data[ RESTRICTION_YAML ],
                   :addresses   => alert_yaml_data[ ADDRESSES_YAML ],
                   :codes       => alert_yaml_data[ CODES_YAML ],
                   :note        => alert_yaml_data[ NOTE_YAML ],
                   :references  => alert_yaml_data[ REFERENCES_YAML ],
                   :incidents   => alert_yaml_data[ INCIDENTS_YAML ],
                   :infos       => Array( alert_yaml_data[ INFOS_YAML ]).map{ |info_yaml_data| Info.from_yaml_data( info_yaml_data )})
      end

      # Initialises an Alert object from a Hash produced by Alert#to_h
      #
      # @param [Hash] alert_hash
      # @return [Alert]
      def self.from_h( alert_hash )
        self.new( :identifier  => alert_hash[ IDENTIFIER_KEY ],
                  :sender      => alert_hash[ SENDER_KEY ],
                  :sent        => RCAP.parse_datetime( alert_hash[ SENT_KEY ]),
                  :status      => alert_hash[ STATUS_KEY ],
                  :msg_type    => alert_hash[ MSG_TYPE_KEY ],
                  :source      => alert_hash[ SOURCE_KEY ],
                  :scope       => alert_hash[ SCOPE_KEY ],
                  :restriction => alert_hash[ RESTRICTION_KEY ],
                  :addresses   => alert_hash[ ADDRESSES_KEY ],
                  :codes       => alert_hash[ CODES_KEY ],
                  :note        => alert_hash[ NOTE_KEY ],
                  :references  => alert_hash[ REFERENCES_KEY ],
                  :incidents   => alert_hash[ INCIDENTS_KEY ],
                  :infos       => Array( alert_hash[ INFOS_KEY ]).map{ |info_hash| Info.from_h( info_hash )})
      end
    end
  end
end
