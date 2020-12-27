# frozen_string_literal: true

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
      XMLNS = 'http://www.incident.com/cap/1.0'
      CAP_VERSION = '1.0'

      # @return [String]
      attr_accessor(:password)

      # @return [String]
      def xmlns
        XMLNS
      end

      # @return [Class]
      def info_class
        Info
      end

      PASSWORD_ELEMENT_NAME = 'password'

      # @return [REXML::Element]
      def to_xml_element
        xml_element = REXML::Element.new(XML_ELEMENT_NAME)
        xml_element.add_namespace(XMLNS)
        xml_element.add_element(IDENTIFIER_ELEMENT_NAME).add_text(@identifier.to_s)   if @identifier
        xml_element.add_element(SENDER_ELEMENT_NAME).add_text(@sender.to_s)           if @sender
        xml_element.add_element(SENT_ELEMENT_NAME).add_text(@sent.to_s_for_cap.to_s)  if @sent
        xml_element.add_element(STATUS_ELEMENT_NAME).add_text(@status.to_s)           if @status
        xml_element.add_element(MSG_TYPE_ELEMENT_NAME).add_text(@msg_type.to_s)       if @msg_type
        xml_element.add_element(PASSWORD_ELEMENT_NAME).add_text(@password.to_s)       if @password
        xml_element.add_element(SOURCE_ELEMENT_NAME).add_text(@source.to_s)           if @source
        xml_element.add_element(SCOPE_ELEMENT_NAME).add_text(@scope.to_s)             if @scope
        xml_element.add_element(RESTRICTION_ELEMENT_NAME).add_text(@restriction.to_s) if @restriction
        xml_element.add_element(ADDRESSES_ELEMENT_NAME).add_text(@addresses.to_s_for_cap) if @addresses.any?
        @codes.each do |code|
          xml_element.add_element(CODE_ELEMENT_NAME).add_text(code.to_s)
        end
        xml_element.add_element(NOTE_ELEMENT_NAME).add_text(@note.to_s) if @note
        xml_element.add_element(REFERENCES_ELEMENT_NAME).add_text(@references.join(' ')) if @references.any?
        xml_element.add_element(INCIDENTS_ELEMENT_NAME).add_text(@incidents.join(' ')) if @incidents.any?
        @infos.each do |info|
          xml_element.add_element(info.to_xml_element)
        end
        xml_element
      end

      # @return [String]
      def inspect
        alert_inspect = ["CAP Version:  #{CAP_VERSION}",
                         "Identifier:   #{@identifier}",
                         "Sender:       #{@sender}",
                         "Sent:         #{@sent}",
                         "Status:       #{@status}",
                         "Message Type: #{@msg_type}",
                         "Password:     #{@password}",
                         "Source:       #{@source}",
                         "Scope:        #{@scope}",
                         "Restriction:  #{@restriction}",
                         "Addresses:    #{@addresses.to_s_for_cap}",
                         'Codes:',
                         @codes.map { |code| '  ' + code }.join("\n"),
                         "Note:         #{@note}",
                         'References:',
                         @references.join("\n "),
                         "Incidents:    #{@incidents.join(' ')}",
                         'Information:',
                         @infos.map { |info| '  ' + info.to_s }.join("\n")].join("\n")
        RCAP.format_lines_for_inspect('ALERT', alert_inspect)
      end

      PASSWORD_XPATH = "cap:#{PASSWORD_ELEMENT_NAME}"

      # @param [REXML::Element] alert_xml_element
      # @return [RCAP::CAP_1_0::Alert]
      def self.from_xml_element(alert_xml_element)
        super.tap do |alert|
          alert.password = RCAP.xpath_text(alert_xml_element, PASSWORD_XPATH, Alert::XMLNS)
        end
      end

      PASSWORD_YAML = 'Password'

      # Returns a string containing the YAML representation of the alert.
      #
      # @return [String]
      def to_yaml(options = {})
        RCAP.attribute_values_to_hash([CAP_VERSION_YAML, CAP_VERSION],
                                      [IDENTIFIER_YAML,  @identifier],
                                      [SENDER_YAML,      @sender],
                                      [SENT_YAML,        @sent],
                                      [STATUS_YAML,      @status],
                                      [MSG_TYPE_YAML,    @msg_type],
                                      [PASSWORD_YAML,    @password],
                                      [SOURCE_YAML,      @source],
                                      [SCOPE_YAML,       @scope],
                                      [RESTRICTION_YAML, @restriction],
                                      [ADDRESSES_YAML,   @addresses],
                                      [CODES_YAML,       @codes],
                                      [NOTE_YAML,        @note],
                                      [REFERENCES_YAML,  @references],
                                      [INCIDENTS_YAML,   @incidents],
                                      [INFOS_YAML,       @infos.map(&:to_yaml_data)]).to_yaml(options)
      end

      # @param [Hash] alert_yaml_data
      # @return [RCAP::CAP_1_0::Alert]
      def self.from_yaml_data(alert_yaml_data)
        super.tap do |alert|
          alert.password = RCAP.strip_if_given(alert_yaml_data[PASSWORD_YAML])
        end
      end

      PASSWORD_KEY = 'password'

      # Returns a Hash representation of an Alert object
      #
      # @return [Hash]
      def to_h
        RCAP.attribute_values_to_hash([CAP_VERSION_KEY, CAP_VERSION],
                                      [IDENTIFIER_KEY,   @identifier],
                                      [SENDER_KEY,       @sender],
                                      [SENT_KEY,         RCAP.to_s_for_cap(@sent)],
                                      [STATUS_KEY,       @status],
                                      [MSG_TYPE_KEY,     @msg_type],
                                      [PASSWORD_KEY,     @password],
                                      [SOURCE_KEY,       @source],
                                      [SCOPE_KEY,        @scope],
                                      [RESTRICTION_KEY,  @restriction],
                                      [ADDRESSES_KEY,    @addresses],
                                      [CODES_KEY,        @codes],
                                      [NOTE_KEY,         @note],
                                      [REFERENCES_KEY,   @references],
                                      [INCIDENTS_KEY,    @incidents],
                                      [INFOS_KEY,        @infos.map(&:to_h)])
      end

      # Initialises an Alert object from a Hash produced by Alert#to_h
      #
      # @param [Hash] alert_hash
      # @return [RCAP::CAP_1_0::Alert]
      def self.from_h(alert_hash)
        super.tap do |alert|
          alert.password = RCAP.strip_if_given(alert_hash[PASSWORD_KEY])
        end
      end
    end
  end
end
