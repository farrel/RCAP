# frozen_string_literal: true

module RCAP
  module CAP_1_1
    # In Info object is valid if
    # * it has an event
    # * it has an urgency with a valid value
    # * it has a severity with a valid value
    # * it has a certainty with a valid value
    # * all categories are valid and categories has at minimum 1 entry
    # * all Resource objects in the resources collection are valid
    # * all Area objects in the areas collection are valid
    class Info < RCAP::Base::Info
      RESPONSE_TYPE_SHELTER  = 'Shelter'
      RESPONSE_TYPE_EVACUATE = 'Evacuate'
      RESPONSE_TYPE_PREPARE  = 'Prepare'
      RESPONSE_TYPE_EXECUTE  = 'Execute'
      RESPONSE_TYPE_MONITOR  = 'Monitor'
      RESPONSE_TYPE_ASSESS   = 'Assess'
      RESPONSE_TYPE_NONE     = 'None'
      # Valid values for response_type
      VALID_RESPONSE_TYPES = [RESPONSE_TYPE_SHELTER, RESPONSE_TYPE_EVACUATE,
                              RESPONSE_TYPE_PREPARE, RESPONSE_TYPE_EXECUTE, RESPONSE_TYPE_MONITOR,
                              RESPONSE_TYPE_ASSESS, RESPONSE_TYPE_NONE].freeze

      CERTAINTY_OBSERVED = 'Observed'
      # Valid valies for certainty
      VALID_CERTAINTIES = [CERTAINTY_OBSERVED, CERTAINTY_LIKELY,
                           CERTAINTY_POSSIBLE, CERTAINTY_UNLIKELY, CERTAINTY_UNKNOWN].freeze

      validates_length_of(:categories, minimum: 1)
      validates_inclusion_of_members_of(:response_types, in: VALID_RESPONSE_TYPES, allow_blank: true)
      validates_inclusion_of(:certainty, allow_nil: true, in: VALID_CERTAINTIES, message: "can only be assigned the following values: #{VALID_CERTAINTIES.join(', ')}")

      # @return [Array<String>] Collection of textual response types; elements must be from {VALID_RESPONSE_TYPES}
      attr_reader(:response_types)
      # @return [Array<EventCode>] Collection of {EventCode} objects
      attr_reader(:event_codes)
      # @return [Array<Parameter>] Collection of {Parameter} objects
      attr_reader(:parameters)
      # @return [Array<Resource> Collection of {Resource} objects
      attr_reader(:resources)
      # @return [Array<Area>] Collection of {Area} objects
      attr_reader(:areas)

      # @param [Hash] attributes
      # @option attributes [String] :language Defaults to {DEFAULT_LANGUAGE}
      # @option attributes [Array<String>] :categories Collection of categories in {VALID_CATEGORIES}
      # @option attributes [String] :audience
      # @option attributes [String] :event
      # @option attributes [Array<String>] :response_types Collection of textual response types from {VALID_RESPONSE_TYPES}
      # @option attributes [String] :urgency A member of {VALID_URGENCIES}
      # @option attributes [String] :severity A member of {VALID_SEVERITIES}
      # @option attributes [String] :certainty A member of {VALID_CERTAINTIES}
      # @option attributes [DateTime] :effective
      # @option attributes [DateTime] :onset
      # @option attributes [DateTime] :expires
      # @option attributes [Array<EventCode>] :event_codes Collection of {EventCode} objects
      # @option attributes [String] :sender_name
      # @option attributes [String] :headline
      # @option attributes [String] :description
      # @option attributes [String] :instruction
      # @option attributes [String] :web URL
      # @option attributes [String] :contact
      # @option attributes [Array<Parameter>] :parameters Collection of {Parameter} objects
      # @option attributes [Array<Resource>] :resources Collection of {Resource} objects
      # @option attributes [Array<Area>] :areas Collection of {Area} objects
      def initialize
        @response_types = []
        super
      end

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

      def xmlns
        Alert::XMLNS
      end

      RESPONSE_TYPE_ELEMENT_NAME = 'responseType'
      RESPONSE_TYPE_XPATH = "cap:#{RESPONSE_TYPE_ELEMENT_NAME}"

      # @return [REXML::Element]
      def to_xml_element
        xml_element = REXML::Element.new(XML_ELEMENT_NAME)
        xml_element.add_element(LANGUAGE_ELEMENT_NAME).add_text(@language.to_s) if @language
        @categories.each do |category|
          xml_element.add_element(CATEGORY_ELEMENT_NAME).add_text(category.to_s)
        end
        xml_element.add_element(EVENT_ELEMENT_NAME).add_text(@event.to_s)
        @response_types.each do |response_type|
          xml_element.add_element(RESPONSE_TYPE_ELEMENT_NAME).add_text(response_type.to_s)
        end
        xml_element.add_element(URGENCY_ELEMENT_NAME).add_text(@urgency.to_s)
        xml_element.add_element(SEVERITY_ELEMENT_NAME).add_text(@severity.to_s)
        xml_element.add_element(CERTAINTY_ELEMENT_NAME).add_text(@certainty.to_s)
        xml_element.add_element(AUDIENCE_ELEMENT_NAME).add_text(@audience.to_s) if @audience
        @event_codes.each do |event_code|
          xml_element.add_element(event_code.to_xml_element)
        end
        xml_element.add_element(EFFECTIVE_ELEMENT_NAME).add_text(@effective.to_s_for_cap) if @effective
        xml_element.add_element(ONSET_ELEMENT_NAME).add_text(@onset.to_s_for_cap)         if @onset
        xml_element.add_element(EXPIRES_ELEMENT_NAME).add_text(@expires.to_s_for_cap)     if @expires
        xml_element.add_element(SENDER_NAME_ELEMENT_NAME).add_text(@sender_name.to_s)     if @sender_name
        xml_element.add_element(HEADLINE_ELEMENT_NAME).add_text(@headline.to_s)           if @headline
        xml_element.add_element(DESCRIPTION_ELEMENT_NAME).add_text(@description.to_s)     if @description
        xml_element.add_element(INSTRUCTION_ELEMENT_NAME).add_text(@instruction.to_s)     if @instruction
        xml_element.add_element(WEB_ELEMENT_NAME).add_text(@web.to_s)                     if @web
        xml_element.add_element(CONTACT_ELEMENT_NAME).add_text(@contact.to_s)             if @contact
        @parameters.each do |parameter|
          xml_element.add_element(parameter.to_xml_element)
        end
        @resources.each do |resource|
          xml_element.add_element(resource.to_xml_element)
        end
        @areas.each do |area|
          xml_element.add_element(area.to_xml_element)
        end
        xml_element
      end

      # @return [String]
      def to_xml
        to_xml_element.to_s
      end

      # @param [REXML::Element] info_xml_element
      # @return [Info]
      def self.from_xml_element(info_xml_element)
        super.tap do |info|
          RCAP.xpath_match(info_xml_element, RESPONSE_TYPE_XPATH, info.xmlns).each do |element|
            info.response_types << RCAP.strip_if_given(element.text)
          end
        end
      end

      # @return [String]
      def inspect
        info_inspect = "Language:       #{@language}\n"\
        "Categories:     #{@categories.to_s_for_cap}\n"\
        "Event:          #{@event}\n"\
        "Response Types: #{@response_types.to_s_for_cap}\n"\
        "Urgency:        #{@urgency}\n"\
        "Severity:       #{@severity}\n"\
        "Certainty:      #{@certainty}\n"\
        "Audience:       #{@audience}\n"\
        "Event Codes:    #{@event_codes.inspect}\n"\
        "Effective:      #{@effective}\n"\
        "Onset:          #{@onset}\n"\
        "Expires:        #{@expires}\n"\
        "Sender Name:    #{@sender_name}\n"\
        "Headline:       #{@headline}\n"\
        "Description:\n" + @description.to_s.lines.map { |line| '  ' + line }.join("\n") + "\n"\
          "Instruction:    #{@instruction}\n"\
        "Web:            #{@web}\n"\
        "Contact:        #{@contact}\n"\
        "Parameters:\n" + @parameters.map { |parameter| '  ' + parameter.inspect }.join("\n") + "\n"\
          "Resources:\n" + @resources.map { |resource| '  ' + resource.inspect }.join("\n") + "\n"\
          "Area:\n" + @areas.map { |area| "  #{area}" }.join("\n") + "\n"
        RCAP.format_lines_for_inspect('INFO', info_inspect)
      end

      # Returns a string representation of the event of the form
      #  event(urgency/severity/certainty)
      #
      # @return [String]
      def to_s
        "#{@event}(#{@urgency}/#{@severity}/#{@certainty})"
      end

      RESPONSE_TYPES_YAML = 'Response Types'

      # @return [Hash]
      def to_yaml_data
        parameter_to_hash = ->(hash, parameter) { hash.merge(parameter.name => parameter.value) }

        RCAP.attribute_values_to_hash([LANGUAGE_YAML,       @language],
                                      [CATEGORIES_YAML,     @categories],
                                      [EVENT_YAML,          @event],
                                      [RESPONSE_TYPES_YAML, @response_types],
                                      [URGENCY_YAML,        @urgency],
                                      [SEVERITY_YAML,       @severity],
                                      [CERTAINTY_YAML,      @certainty],
                                      [AUDIENCE_YAML,       @audience],
                                      [EFFECTIVE_YAML,      @effective],
                                      [ONSET_YAML,          @onset],
                                      [EXPIRES_YAML,        @expires],
                                      [SENDER_NAME_YAML,    @sender_name],
                                      [HEADLINE_YAML,       @headline],
                                      [DESCRIPTION_YAML,    @description],
                                      [INSTRUCTION_YAML,    @instruction],
                                      [WEB_YAML,            @web],
                                      [CONTACT_YAML,        @contact],
                                      [EVENT_CODES_YAML,    @event_codes.inject({}, &parameter_to_hash)],
                                      [PARAMETERS_YAML,     @parameters.inject({}, &parameter_to_hash)],
                                      [RESOURCES_YAML,      @resources.map(&:to_yaml_data)],
                                      [AREAS_YAML,          @areas.map(&:to_yaml_data)])
      end

      # @return [String]
      def to_yaml(options = {})
        to_yaml_data.to_yaml(options)
      end

      # @param [Hash] info_yaml_data
      # @return [Info]
      def self.from_yaml_data(info_yaml_data)
        super.tap do |info|
          Array(info_yaml_data [RESPONSE_TYPES_YAML]).each do |response_type|
            info.response_types << RCAP.strip_if_given(response_type)
          end
        end
      end

      RESPONSE_TYPES_KEY = 'response_types'

      # @return [Hash]
      def to_h
        RCAP.attribute_values_to_hash([LANGUAGE_KEY,       @language],
                                      [CATEGORIES_KEY,     @categories],
                                      [EVENT_KEY,          @event],
                                      [RESPONSE_TYPES_KEY, @response_types],
                                      [URGENCY_KEY,        @urgency],
                                      [SEVERITY_KEY,       @severity],
                                      [CERTAINTY_KEY,      @certainty],
                                      [AUDIENCE_KEY,       @audience],
                                      [EFFECTIVE_KEY,      RCAP.to_s_for_cap(@effective)],
                                      [ONSET_KEY,          RCAP.to_s_for_cap(@onset)],
                                      [EXPIRES_KEY,        RCAP.to_s_for_cap(@expires)],
                                      [SENDER_NAME_KEY,    @sender_name],
                                      [HEADLINE_KEY,       @headline],
                                      [DESCRIPTION_KEY,    @description],
                                      [INSTRUCTION_KEY,    @instruction],
                                      [WEB_KEY,            @web],
                                      [CONTACT_KEY,        @contact],
                                      [RESOURCES_KEY,      @resources.map(&:to_h)],
                                      [EVENT_CODES_KEY,    @event_codes.map(&:to_h)],
                                      [PARAMETERS_KEY,     @parameters.map(&:to_h)],
                                      [AREAS_KEY,          @areas.map(&:to_h)])
      end

      # @param [Hash] info_hash
      # @return [Info]
      def self.from_h(info_hash)
        super.tap do |info|
          Array(info_hash[RESPONSE_TYPES_KEY]).each do |response_type|
            info.response_types << RCAP.strip_if_given(response_type)
          end
        end
      end
    end
  end
end
