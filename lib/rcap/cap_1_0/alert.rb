module RCAP
  module CAP_1_0

    # An Alert object is valid if
    # * it has an identifier
    # * it has a sender
    # * it has a sent time
    # * it has a valid status value
    # * it has a valid messge type value
    # * it has a valid scope value
    # * all Info objects contained in infos are valid
    class Alert < RCAP::Base::Alert

      XMLNS = "http://www.incident.com/cap/1.0"
      CAP_VERSION = "1.0"

      # @return [String]
      attr_accessor( :password )

      def xmlns
        XMLNS
      end

      def info_class
        Info
      end

      PASSWORD_ELEMENT_NAME    = 'password'    

      # @return [REXML::Element]
      def to_xml_element 
        xml_element = REXML::Element.new( XML_ELEMENT_NAME )
        xml_element.add_namespace( XMLNS )
        xml_element.add_element( IDENTIFIER_ELEMENT_NAME ).add_text( @identifier )   if @identifier
        xml_element.add_element( SENDER_ELEMENT_NAME ).add_text( @sender )           if @sender
        xml_element.add_element( SENT_ELEMENT_NAME ).add_text( @sent.to_s_for_cap )  if @sent
        xml_element.add_element( STATUS_ELEMENT_NAME ).add_text( @status )           if @status
        xml_element.add_element( MSG_TYPE_ELEMENT_NAME ).add_text( @msg_type )       if @msg_type
        xml_element.add_element( PASSWORD_ELEMENT_NAME ).add_text( @password )       if @password
        xml_element.add_element( SOURCE_ELEMENT_NAME ).add_text( @source )           if @source
        xml_element.add_element( SCOPE_ELEMENT_NAME ).add_text( @scope )             if @scope
        xml_element.add_element( RESTRICTION_ELEMENT_NAME ).add_text( @restriction ) if @restriction
        if @addresses.any?
          xml_element.add_element( ADDRESSES_ELEMENT_NAME ).add_text( @addresses.to_s_for_cap )
        end
        @codes.each do |code|
          xml_element.add_element( CODE_ELEMENT_NAME ).add_text( code )
        end
        xml_element.add_element( NOTE_ELEMENT_NAME ).add_text( @note ) if @note
        if @references.any?
          xml_element.add_element( REFERENCES_ELEMENT_NAME ).add_text( @references.join( ' ' ))
        end
        if @incidents.any?
          xml_element.add_element( INCIDENTS_ELEMENT_NAME ).add_text( @incidents.join( ' ' ))
        end
        @infos.each do |info|
          xml_element.add_element( info.to_xml_element )
        end
        xml_element
      end

      # @return [String]
      def inspect 
        alert_inspect = [ "CAP Version:  #{ CAP_VERSION }",
                          "Identifier:   #{ @identifier }",
                          "Sender:       #{ @sender }",
                          "Sent:         #{ @sent }",
                          "Status:       #{ @status }",
                          "Message Type: #{ @msg_type }",
                          "Password:     #{ @password }",
                          "Source:       #{ @source }",
                          "Scope:        #{ @scope }",
                          "Restriction:  #{ @restriction }",
                          "Addresses:    #{ @addresses.to_s_for_cap }",
                          "Codes:",
                          @codes.map{ |code| "  " + code }.join("\n"),
                          "Note:         #{ @note }",
                          "References:   #{ @references.join( ' ' )}",
                          "Incidents:    #{ @incidents.join( ' ')}",
                          "Information:",
                          @infos.map{ |info| "  " + info.to_s }.join( "\n" )].join("\n")
        RCAP.format_lines_for_inspect( 'ALERT', alert_inspect )
      end


      PASSWORD_XPATH    = "cap:#{ PASSWORD_ELEMENT_NAME }"    

      # @param [REXML::Element] alert_xml_element
      # @return [RCAP::CAP_1_0::Alert]
      def self.from_xml_element( alert_xml_element ) 
        alert = super( alert_xml_element )
        alert.password = RCAP.xpath_text( alert_xml_element, PASSWORD_XPATH, Alert::XMLNS )
        alert
      end


      PASSWORD_YAML    = "Password"           

      # Returns a string containing the YAML representation of the alert.
      #
      # @return [String]
      def to_yaml( options = {} )
        RCAP.attribute_values_to_hash( [ CAP_VERSION_YAML, CAP_VERSION ],
                                       [ IDENTIFIER_YAML,  @identifier ],
                                       [ SENDER_YAML,      @sender ],
                                       [ SENT_YAML,        @sent ],
                                       [ STATUS_YAML,      @status ],
                                       [ MSG_TYPE_YAML,    @msg_type ],
                                       [ PASSWORD_YAML,    @password ],
                                       [ SOURCE_YAML,      @source ],
                                       [ SCOPE_YAML,       @scope ],
                                       [ RESTRICTION_YAML, @restriction ],
                                       [ ADDRESSES_YAML,   @addresses ],
                                       [ CODES_YAML,       @codes ],
                                       [ NOTE_YAML,        @note ],
                                       [ REFERENCES_YAML,  @references ],
                                       [ INCIDENTS_YAML,   @incidents ],
                                       [ INFOS_YAML,       @infos ]).to_yaml( options )
      end

      # @param [Hash] alert_yaml_data
      # @return [RCAP::CAP_1_0::Alert]
      def self.from_yaml_data( alert_yaml_data ) 
        Alert.new( :identifier  => alert_yaml_data[ IDENTIFIER_YAML ],
                   :sender      => alert_yaml_data[ SENDER_YAML ],
                   :sent        => ( sent = alert_yaml_data[ SENT_YAML ]).blank? ? nil : DateTime.parse( sent.to_s ),
                   :status      => alert_yaml_data[ STATUS_YAML ],
                   :msg_type    => alert_yaml_data[ MSG_TYPE_YAML ],
                   :password    => alert_yaml_data[ PASSWORD_YAML ],
                   :source      => alert_yaml_data[ SOURCE_YAML ],
                   :scope       => alert_yaml_data[ SCOPE_YAML ],
                   :restriction => alert_yaml_data[ RESTRICTION_YAML ],
                   :addresses   => alert_yaml_data[ ADDRESSES_YAML ],
                   :codes       => alert_yaml_data[ CODES_YAML ],
                   :note        => alert_yaml_data[ NOTE_YAML ],
                   :references  => alert_yaml_data[ REFERENCES_YAML ],
                   :incidents   => alert_yaml_data[ INCIDENTS_YAML ],
                   :infos       => Array( alert_yaml_data[ INFOS_YAML ]).map{ |info_yaml_data| Info.from_yaml_data( info_yaml_data )}
        )
      end

      PASSWORD_KEY    = 'password'    

      # Returns a Hash representation of an Alert object
      #
      # @return [Hash]
      def to_h
        RCAP.attribute_values_to_hash( [ CAP_VERSION_KEY, CAP_VERSION ],
                                       [ IDENTIFIER_KEY,   @identifier ],
                                       [ SENDER_KEY,       @sender ],
                                       [ SENT_KEY,         RCAP.to_s_for_cap( @sent )],
                                       [ STATUS_KEY,       @status ],
                                       [ MSG_TYPE_KEY,     @msg_type ],
                                       [ PASSWORD_KEY,     @password ],
                                       [ SOURCE_KEY,       @source ],
                                       [ SCOPE_KEY,        @scope ],
                                       [ RESTRICTION_KEY,  @restriction ],
                                       [ ADDRESSES_KEY,    @addresses ],
                                       [ CODES_KEY,        @codes ],
                                       [ NOTE_KEY,         @note ],
                                       [ REFERENCES_KEY,   @references ],
                                       [ INCIDENTS_KEY,    @incidents ],
                                       [ INFOS_KEY,        @infos.map{ |info| info.to_h  }])
      end

      # Initialises an Alert object from a Hash produced by Alert#to_h
      #
      # @param [Hash] alert_hash
      # @return [RCAP::CAP_1_0::Alert]
      def self.from_h( alert_hash )
        alert = super
        alert.password = alert_hash[ PASSWORD_KEY ]
        alert
      end
    end
  end
end
