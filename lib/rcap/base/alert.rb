# frozen_string_literal: true

module RCAP
  module Base
    class Alert
      include Validation

      STATUS_ACTUAL   = 'Actual'
      STATUS_EXERCISE = 'Exercise'
      STATUS_SYSTEM   = 'System'
      STATUS_TEST     = 'Test'
      # Valid values for status
      VALID_STATUSES = [STATUS_ACTUAL, STATUS_EXERCISE, STATUS_SYSTEM, STATUS_TEST].freeze

      MSG_TYPE_ALERT  = 'Alert'
      MSG_TYPE_UPDATE = 'Update'
      MSG_TYPE_CANCEL = 'Cancel'
      MSG_TYPE_ACK    = 'Ack'
      MSG_TYPE_ERROR  = 'Error'
      # Valid values for msg_type
      VALID_MSG_TYPES = [MSG_TYPE_ALERT, MSG_TYPE_UPDATE, MSG_TYPE_CANCEL, MSG_TYPE_ACK, MSG_TYPE_ERROR].freeze

      SCOPE_PUBLIC     = 'Public'
      SCOPE_RESTRICTED = 'Restricted'
      SCOPE_PRIVATE    = 'Private'
      # Valid values for scope
      VALID_SCOPES = [SCOPE_PUBLIC, SCOPE_PRIVATE, SCOPE_RESTRICTED].freeze

      # @return [String] If not set a UUID will be set by default on object initialisation
      attr_accessor(:identifier)
      # @return [String]
      attr_accessor(:sender)
      # @return [DateTime] If not set will be time of creation.
      attr_accessor(:sent)
      # @return [String] Can only be one of {VALID_STATUSES}
      attr_accessor(:status)
      # @return [String] Can only be one of {VALID_MSG_TYPES}
      attr_accessor(:msg_type)
      # @return [String] Can only be one of {VALID_SCOPES}
      attr_accessor(:scope)
      # @return [String]
      attr_accessor(:source)
      # @return [String ] Required if scope is {SCOPE_RESTRICTED}
      attr_accessor(:restriction)
      # @return [String]
      attr_accessor(:note)

      # @return [Array<String>] Collection of address strings. Depends on scope being {SCOPE_PRIVATE}
      attr_reader(:addresses)
      # @return [Array<String>]
      attr_reader(:codes)
      # @return [Array<String>] Collection of references to previous alerts
      # @see #to_reference
      attr_reader(:references)
      # @return [Array<String>] Collection of incident strings
      attr_reader(:incidents)
      # @return [Array<Info>]
      attr_reader(:infos)

      validates_presence_of(:identifier, :sender, :sent, :status, :msg_type, :scope)

      validates_inclusion_of(:status,   in: VALID_STATUSES)
      validates_inclusion_of(:msg_type, in: VALID_MSG_TYPES)
      validates_inclusion_of(:scope,    in: VALID_SCOPES)

      validates_format_of(:identifier, with: ALLOWED_CHARACTERS)
      validates_format_of(:sender,     with: ALLOWED_CHARACTERS)

      validates_conditional_presence_of(:addresses,   when: :scope, is: SCOPE_PRIVATE)
      validates_conditional_presence_of(:restriction, when: :scope, is: SCOPE_RESTRICTED)

      validates_collection_of(:infos)

      # Initialises a new Alert object. Yields the initialised alert to a block.
      #
      # @example
      #   alert = RCAP::CAP_1_2::Alert.new do |alert|
      #             alert.sender = alerts@example.org
      #             alert.status = Alert::STATUS_ACTUAL
      #             alert.msg_type = Alert::MSG_TYPE_ALERT
      #             alert.scope = Alert::SCOPE_PUBLIC
      #           end
      #
      # @yieldparam alert [Alert] The newly initialised Alert.
      def initialize
        @identifier  = RCAP.generate_identifier
        @addresses   = []
        @codes       = []
        @references  = []
        @incidents   = []
        @infos       = []
        yield(self) if block_given?
      end

      # Creates a new {Info} object and adds it to the {#infos} array.
      #
      # @see Info#initialize
      # @yield [Info] The newly initialised Info object.
      # @return [Info] The initialised Info object after being yielded to the block
      def add_info
        info_class.new.tap do |info|
          yield(info) if block_given?
          @infos << info
        end
      end

      XML_ELEMENT_NAME         = 'alert'
      IDENTIFIER_ELEMENT_NAME  = 'identifier'
      SENDER_ELEMENT_NAME      = 'sender'
      SENT_ELEMENT_NAME        = 'sent'
      STATUS_ELEMENT_NAME      = 'status'
      MSG_TYPE_ELEMENT_NAME    = 'msgType'
      SOURCE_ELEMENT_NAME      = 'source'
      SCOPE_ELEMENT_NAME       = 'scope'
      RESTRICTION_ELEMENT_NAME = 'restriction'
      ADDRESSES_ELEMENT_NAME   = 'addresses'
      CODE_ELEMENT_NAME        = 'code'
      NOTE_ELEMENT_NAME        = 'note'
      REFERENCES_ELEMENT_NAME  = 'references'
      INCIDENTS_ELEMENT_NAME   = 'incidents'

      # @return [REXML::Element]
      def to_xml_element
        xml_element = REXML::Element.new(XML_ELEMENT_NAME)
        xml_element.add_namespace(self.class::XMLNS)
        xml_element.add_element(IDENTIFIER_ELEMENT_NAME).add_text(@identifier.to_s)   if @identifier
        xml_element.add_element(SENDER_ELEMENT_NAME).add_text(@sender.to_s)           if @sender
        xml_element.add_element(SENT_ELEMENT_NAME).add_text(@sent.to_s_for_cap)       if @sent
        xml_element.add_element(STATUS_ELEMENT_NAME).add_text(@status.to_s)           if @status
        xml_element.add_element(MSG_TYPE_ELEMENT_NAME).add_text(@msg_type.to_s)       if @msg_type
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

      # @return [REXML::Document]
      def to_xml_document
        xml_document = REXML::Document.new
        xml_document.add(REXML::XMLDecl.new)
        xml_document.add(to_xml_element)
        xml_document
      end

      # Returns a string containing the XML representation of the alert.
      #
      # @param [true,false] pretty_print Pretty print output
      # @return [String]
      def to_xml(pretty_print = false)
        if pretty_print
          xml_document = +''
          RCAP::XML_PRETTY_PRINTER.write(to_xml_document, xml_document)
          xml_document
        else
          to_xml_document.to_s
        end
      end

      # Returns a string representation of the alert suitable for usage as a reference in a CAP message of the form
      #  sender,identifier,sent
      #
      # @return [String]
      def to_reference
        "#{@sender},#{@identifier},#{RCAP.to_s_for_cap(@sent)}"
      end

      # @return [String]
      def inspect
        alert_inspect = ["CAP Version:  #{self.class::CAP_VERSION}",
                         "Identifier:   #{@identifier}",
                         "Sender:       #{@sender}",
                         "Sent:         #{@sent}",
                         "Status:       #{@status}",
                         "Message Type: #{@msg_type}",
                         "Source:       #{@source}",
                         "Scope:        #{@scope}",
                         "Restriction:  #{@restriction}",
                         "Addresses:    #{@addresses.to_s_for_cap}",
                         'Codes:',
                         @codes.map { |code| '  ' + code }.join("\n") + '',
                         "Note:         #{@note}",
                         'References:',
                         @references.join("\n "),
                         "Incidents:    #{@incidents.join(' ')}",
                         'Information:',
                         @infos.map { |info| '  ' + info.to_s }.join("\n")].join("\n")
        RCAP.format_lines_for_inspect('ALERT', alert_inspect)
      end

      # Returns a string representation of the alert of the form
      #  sender/identifier/sent
      # See {#to_reference} for another string representation suitable as a CAP reference.
      #
      # @return [String]
      def to_s
        "#{@sender}/#{@identifier}/#{RCAP.to_s_for_cap(@sent)}"
      end

      XPATH             = 'cap:alert'
      IDENTIFIER_XPATH  = "cap:#{IDENTIFIER_ELEMENT_NAME}"
      SENDER_XPATH      = "cap:#{SENDER_ELEMENT_NAME}"
      SENT_XPATH        = "cap:#{SENT_ELEMENT_NAME}"
      STATUS_XPATH      = "cap:#{STATUS_ELEMENT_NAME}"
      MSG_TYPE_XPATH    = "cap:#{MSG_TYPE_ELEMENT_NAME}"
      SOURCE_XPATH      = "cap:#{SOURCE_ELEMENT_NAME}"
      SCOPE_XPATH       = "cap:#{SCOPE_ELEMENT_NAME}"
      RESTRICTION_XPATH = "cap:#{RESTRICTION_ELEMENT_NAME}"
      ADDRESSES_XPATH   = "cap:#{ADDRESSES_ELEMENT_NAME}"
      CODE_XPATH        = "cap:#{CODE_ELEMENT_NAME}"
      NOTE_XPATH        = "cap:#{NOTE_ELEMENT_NAME}"
      REFERENCES_XPATH  = "cap:#{REFERENCES_ELEMENT_NAME}"
      INCIDENTS_XPATH   = "cap:#{INCIDENTS_ELEMENT_NAME}"

      # @param [REXML::Element] alert_xml_element
      # @return [RCAP::CAP_1_0::Alert]
      def self.from_xml_element(alert_xml_element)
        new do |alert|
          alert.identifier  = RCAP.xpath_text(alert_xml_element, IDENTIFIER_XPATH, alert.xmlns)
          alert.sender      = RCAP.xpath_text(alert_xml_element, SENDER_XPATH, alert.xmlns)
          alert.sent        = RCAP.parse_datetime(RCAP.xpath_text(alert_xml_element, SENT_XPATH, alert.xmlns))
          alert.status      = RCAP.xpath_text(alert_xml_element, STATUS_XPATH, alert.xmlns)
          alert.msg_type    = RCAP.xpath_text(alert_xml_element, MSG_TYPE_XPATH, alert.xmlns)
          alert.source      = RCAP.xpath_text(alert_xml_element, SOURCE_XPATH, alert.xmlns)
          alert.scope       = RCAP.xpath_text(alert_xml_element, SCOPE_XPATH, alert.xmlns)
          alert.restriction = RCAP.xpath_text(alert_xml_element, RESTRICTION_XPATH, alert.xmlns)

          RCAP.unpack_if_given(RCAP.xpath_text(alert_xml_element, ADDRESSES_XPATH, alert.xmlns)).each do |address|
            alert.addresses << address.strip
          end

          RCAP.xpath_match(alert_xml_element, CODE_XPATH, alert.xmlns).each do |element|
            alert.codes << element.text.strip
          end

          alert.note = RCAP.xpath_text(alert_xml_element, NOTE_XPATH, alert.xmlns)

          RCAP.unpack_if_given(RCAP.xpath_text(alert_xml_element, REFERENCES_XPATH, alert.xmlns)).each do |reference|
            alert.references << reference.strip
          end

          RCAP.unpack_if_given(RCAP.xpath_text(alert_xml_element, INCIDENTS_XPATH, alert.xmlns)).each do |incident|
            alert.incidents << incident.strip
          end

          RCAP.xpath_match(alert_xml_element, Info::XPATH, alert.xmlns).each do |element|
            alert.infos << alert.info_class.from_xml_element(element)
          end
        end
      end

      # @param [REXML::Document] xml_document
      # @return [Alert]
      def self.from_xml_document(xml_document)
        from_xml_element(xml_document.root)
      end

      # Initialise an Alert object from an XML string. Any object that is a subclass of IO (e.g. File) can be passed in.
      #
      # @param [String] xml
      # @return [Alert]
      def self.from_xml(xml)
        from_xml_document(REXML::Document.new(xml))
      end

      CAP_VERSION_YAML = 'CAP Version'
      IDENTIFIER_YAML  = 'Identifier'
      SENDER_YAML      = 'Sender'
      SENT_YAML        = 'Sent'
      STATUS_YAML      = 'Status'
      MSG_TYPE_YAML    = 'Message Type'
      SOURCE_YAML      = 'Source'
      SCOPE_YAML       = 'Scope'
      RESTRICTION_YAML = 'Restriction'
      ADDRESSES_YAML   = 'Addresses'
      CODES_YAML       = 'Codes'
      NOTE_YAML        = 'Note'
      REFERENCES_YAML  = 'References'
      INCIDENTS_YAML   = 'Incidents'
      INFOS_YAML       = 'Information'

      # Returns a string containing the YAML representation of the alert.
      #
      # @return [String]
      def to_yaml(options = {})
        RCAP.attribute_values_to_hash([CAP_VERSION_YAML, self.class::CAP_VERSION],
                                      [IDENTIFIER_YAML,  @identifier],
                                      [SENDER_YAML,      @sender],
                                      [SENT_YAML,        @sent],
                                      [STATUS_YAML,      @status],
                                      [MSG_TYPE_YAML,    @msg_type],
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

      # Initialise an Alert object from a YAML string. Any object that is a subclass of IO (e.g. File) can be passed in.
      #
      # @param [String] yaml
      # @return [Alert]
      def self.from_yaml(yaml)
        from_yaml_data(YAML.safe_load(yaml, [Time, DateTime]))
      end

      # Initialise an Alert object from a hash reutrned from YAML.load.
      #
      # @param [hash] alert_yaml_data
      # @return [Alert]
      def self.from_yaml_data(alert_yaml_data)
        new do |alert|
          alert.identifier  = RCAP.strip_if_given(alert_yaml_data[IDENTIFIER_YAML])
          alert.sender      = RCAP.strip_if_given(alert_yaml_data[SENDER_YAML])
          alert.sent        = RCAP.parse_datetime(alert_yaml_data[SENT_YAML])
          alert.status      = RCAP.strip_if_given(alert_yaml_data[STATUS_YAML])
          alert.msg_type    = RCAP.strip_if_given(alert_yaml_data[MSG_TYPE_YAML])
          alert.source      = RCAP.strip_if_given(alert_yaml_data[SOURCE_YAML])
          alert.scope       = RCAP.strip_if_given(alert_yaml_data[SCOPE_YAML])
          alert.restriction = RCAP.strip_if_given(alert_yaml_data[RESTRICTION_YAML])
          Array(alert_yaml_data[ADDRESSES_YAML]).each do |address|
            alert.addresses << address.strip
          end
          Array(alert_yaml_data[CODES_YAML]).each do |code|
            alert.codes << code.strip
          end
          alert.note = alert_yaml_data[NOTE_YAML]
          Array(alert_yaml_data[REFERENCES_YAML]).each do |reference|
            alert.references << reference.strip
          end
          Array(alert_yaml_data[INCIDENTS_YAML]).each do |incident|
            alert.incidents << incident.strip
          end
          Array(alert_yaml_data[INFOS_YAML]).each do |info_yaml_data|
            alert.infos <<  alert.info_class.from_yaml_data(info_yaml_data)
          end
        end
      end

      CAP_VERSION_KEY = 'cap_version'
      IDENTIFIER_KEY  = 'identifier'
      SENDER_KEY      = 'sender'
      SENT_KEY        = 'sent'
      STATUS_KEY      = 'status'
      MSG_TYPE_KEY    = 'msg_type'
      SOURCE_KEY      = 'source'
      SCOPE_KEY       = 'scope'
      RESTRICTION_KEY = 'restriction'
      ADDRESSES_KEY   = 'addresses'
      CODES_KEY       = 'codes'
      NOTE_KEY        = 'note'
      REFERENCES_KEY  = 'references'
      INCIDENTS_KEY   = 'incidents'
      INFOS_KEY       = 'infos'

      # Returns a Hash representation of an Alert object
      #
      # @return [Hash]
      def to_h
        RCAP.attribute_values_to_hash([CAP_VERSION_KEY, self.class::CAP_VERSION],
                                      [IDENTIFIER_KEY,  @identifier],
                                      [SENDER_KEY,      @sender],
                                      [SENT_KEY,        RCAP.to_s_for_cap(@sent)],
                                      [STATUS_KEY,      @status],
                                      [MSG_TYPE_KEY,    @msg_type],
                                      [SOURCE_KEY,      @source],
                                      [SCOPE_KEY,       @scope],
                                      [RESTRICTION_KEY, @restriction],
                                      [ADDRESSES_KEY,   @addresses],
                                      [CODES_KEY,       @codes],
                                      [NOTE_KEY,        @note],
                                      [REFERENCES_KEY,  @references],
                                      [INCIDENTS_KEY,   @incidents],
                                      [INFOS_KEY,       @infos.map(&:to_h)])
      end

      # Initialises an Alert object from a Hash produced by Alert#to_h
      #
      # @param [Hash] alert_hash
      # @return [RCAP::CAP_1_0::Alert]
      def self.from_h(alert_hash)
        new do |alert|
          alert.identifier  = RCAP.strip_if_given(alert_hash[IDENTIFIER_KEY])
          alert.sender      = RCAP.strip_if_given(alert_hash[SENDER_KEY])
          alert.sent        = RCAP.parse_datetime(alert_hash[SENT_KEY])
          alert.status      = RCAP.strip_if_given(alert_hash[STATUS_KEY])
          alert.msg_type    = RCAP.strip_if_given(alert_hash[MSG_TYPE_KEY])
          alert.source      = RCAP.strip_if_given(alert_hash[SOURCE_KEY])
          alert.scope       = RCAP.strip_if_given(alert_hash[SCOPE_KEY])
          alert.restriction = RCAP.strip_if_given(alert_hash[RESTRICTION_KEY])
          Array(alert_hash[ADDRESSES_KEY]).each do |address|
            alert.addresses << address.strip
          end
          Array(alert_hash[CODES_KEY]).each do |code|
            alert.codes << code.strip
          end
          alert.note = alert_hash[NOTE_KEY]
          Array(alert_hash[REFERENCES_KEY]).each do |reference|
            alert.references << reference.strip
          end

          Array(alert_hash[INCIDENTS_KEY]).each do |incident|
            alert.incidents << incident.strip
          end

          Array(alert_hash[INFOS_KEY]).each do |info_hash|
            alert.infos << alert.info_class.from_h(info_hash)
          end
        end
      end

      # Returns a JSON string representation of an Alert object
      #
      # @param [true,false] pretty_print
      # @return [String]
      def to_json(pretty_print = false)
        if pretty_print
          JSON.pretty_generate(to_h)
        else
          to_h.to_json
        end
      end

      # Initialises an Alert object from a JSON string produced by Alert#to_json
      #
      # @param [String] json_string
      # @return [Alert]
      def self.from_json(json_string)
        from_h(JSON.parse(json_string))
      end
    end
  end
end
