# frozen_string_literal: true

module RCAP
  module Base
    class Info
      include Validation

      CATEGORY_GEO       = 'Geo'
      CATEGORY_MET       = 'Met'
      CATEGORY_SAFETY    = 'Safety'
      CATEGORY_SECURITY  = 'Security'
      CATEGORY_RESCUE    = 'Rescue'
      CATEGORY_FIRE      = 'Fire'
      CATEGORY_HEALTH    = 'Health'
      CATEGORY_ENV       = 'Env'
      CATEGORY_TRANSPORT = 'Transport'
      CATEGORY_INFRA     = 'Infra'
      CATEGORY_CBRNE     = 'CBRNE'
      CATEGORY_OTHER     = 'Other'
      # Valid values for categories
      VALID_CATEGORIES = [CATEGORY_GEO, CATEGORY_MET, CATEGORY_SAFETY,
                          CATEGORY_SECURITY, CATEGORY_RESCUE, CATEGORY_FIRE, CATEGORY_HEALTH,
                          CATEGORY_ENV, CATEGORY_TRANSPORT, CATEGORY_INFRA, CATEGORY_CBRNE,
                          CATEGORY_OTHER].freeze

      URGENCY_IMMEDIATE = 'Immediate'
      URGENCY_EXPECTED  = 'Expected'
      URGENCY_FUTURE    = 'Future'
      URGENCY_PAST      = 'Past'
      URGENCY_UNKNOWN   = 'Unknown'
      # Valid values for urgency
      VALID_URGENCIES = [URGENCY_IMMEDIATE, URGENCY_EXPECTED, URGENCY_FUTURE,
                         URGENCY_PAST, URGENCY_UNKNOWN].freeze

      SEVERITY_EXTREME  = 'Extreme'
      SEVERITY_SEVERE   = 'Severe'
      SEVERITY_MODERATE = 'Moderate'
      SEVERITY_MINOR    = 'Minor'
      SEVERITY_UNKNOWN  = 'Unknown'
      # Valid values for severity
      VALID_SEVERITIES = [SEVERITY_EXTREME, SEVERITY_SEVERE, SEVERITY_MODERATE,
                          SEVERITY_MINOR, SEVERITY_UNKNOWN].freeze

      CERTAINTY_VERY_LIKELY = 'Very Likely'
      CERTAINTY_LIKELY      = 'Likely'
      CERTAINTY_POSSIBLE    = 'Possible'
      CERTAINTY_UNLIKELY    = 'Unlikely'
      CERTAINTY_UNKNOWN     = 'Unknown'
      # Valid valies for certainty
      VALID_CERTAINTIES = [CERTAINTY_VERY_LIKELY, CERTAINTY_LIKELY,
                           CERTAINTY_POSSIBLE, CERTAINTY_UNLIKELY, CERTAINTY_UNKNOWN].freeze

      XML_ELEMENT_NAME           = 'info'
      LANGUAGE_ELEMENT_NAME      = 'language'
      CATEGORY_ELEMENT_NAME      = 'category'
      EVENT_ELEMENT_NAME         = 'event'
      URGENCY_ELEMENT_NAME       = 'urgency'
      SEVERITY_ELEMENT_NAME      = 'severity'
      CERTAINTY_ELEMENT_NAME     = 'certainty'
      AUDIENCE_ELEMENT_NAME      = 'audience'
      EVENT_CODE_ELEMENT_NAME    = 'eventCode'
      EFFECTIVE_ELEMENT_NAME     = 'effective'
      ONSET_ELEMENT_NAME         = 'onset'
      EXPIRES_ELEMENT_NAME       = 'expires'
      SENDER_NAME_ELEMENT_NAME   = 'senderName'
      HEADLINE_ELEMENT_NAME      = 'headline'
      DESCRIPTION_ELEMENT_NAME   = 'description'
      INSTRUCTION_ELEMENT_NAME   = 'instruction'
      WEB_ELEMENT_NAME           = 'web'
      CONTACT_ELEMENT_NAME       = 'contact'

      XPATH               = "cap:#{XML_ELEMENT_NAME}"
      LANGUAGE_XPATH      = "cap:#{LANGUAGE_ELEMENT_NAME}"
      EVENT_XPATH         = "cap:#{EVENT_ELEMENT_NAME}"
      URGENCY_XPATH       = "cap:#{URGENCY_ELEMENT_NAME}"
      CATEGORY_XPATH      = "cap:#{CATEGORY_ELEMENT_NAME}"
      SEVERITY_XPATH      = "cap:#{SEVERITY_ELEMENT_NAME}"
      CERTAINTY_XPATH     = "cap:#{CERTAINTY_ELEMENT_NAME}"
      AUDIENCE_XPATH      = "cap:#{AUDIENCE_ELEMENT_NAME}"
      EVENT_CODE_XPATH    = "cap:#{EVENT_CODE_ELEMENT_NAME}"
      EFFECTIVE_XPATH     = "cap:#{EFFECTIVE_ELEMENT_NAME}"
      ONSET_XPATH         = "cap:#{ONSET_ELEMENT_NAME}"
      EXPIRES_XPATH       = "cap:#{EXPIRES_ELEMENT_NAME}"
      SENDER_NAME_XPATH   = "cap:#{SENDER_NAME_ELEMENT_NAME}"
      HEADLINE_XPATH      = "cap:#{HEADLINE_ELEMENT_NAME}"
      DESCRIPTION_XPATH   = "cap:#{DESCRIPTION_ELEMENT_NAME}"
      INSTRUCTION_XPATH   = "cap:#{INSTRUCTION_ELEMENT_NAME}"
      WEB_XPATH           = "cap:#{WEB_ELEMENT_NAME}"
      CONTACT_XPATH       = "cap:#{CONTACT_ELEMENT_NAME}"

      DEFAULT_LANGUAGE = 'en-US'

      validates_presence_of(:event)
      validates_presence_of(:urgency)
      validates_presence_of(:severity)
      validates_presence_of(:certainty)
      validates_inclusion_of(:severity, allow_nil: true, in: VALID_SEVERITIES, message: "can only be assigned the following values: #{VALID_SEVERITIES.join(', ')}")
      validates_inclusion_of(:urgency, allow_nil: true, in: VALID_URGENCIES, message: "can only be assigned the following values: #{VALID_URGENCIES.join(', ')}")
      validates_inclusion_of_members_of(:categories, in: VALID_CATEGORIES, allow_blank: true)
      validates_collection_of(:resources, :areas, :event_codes, :parameters)

      # @return [String]
      attr_accessor(:event)
      # @return [String] Value can only be one of {VALID_URGENCIES}
      attr_accessor(:urgency)
      # @return [String] Value can only be one of {VALID_SEVERITIES}
      attr_accessor(:severity)
      # @return [String] Value can only be one of {VALID_CERTAINTIES}
      attr_accessor(:certainty)
      # @return [String]
      attr_accessor(:language)
      # @return [String]
      attr_accessor(:audience)
      # @return [DateTime] Effective start time of information
      attr_accessor(:effective)
      # @return [DateTime] Expected start of event
      attr_accessor(:onset)
      # @return [DateTime] Effective expiry time of information
      attr_accessor(:expires)
      # @return [String]
      attr_accessor(:sender_name)
      # @return [String]
      attr_accessor(:headline)
      # @return [String]
      attr_accessor(:description)
      # @return [String]
      attr_accessor(:instruction)
      # @return [String]
      attr_accessor(:web)
      # @return [String]
      attr_accessor(:contact)

      # @return [Array<String>] Collection of textual categories; elements can be one of {VALID_CATEGORIES}
      attr_reader(:categories)
      # @return [Array<EventCode>] Collection of {EventCode} objects
      attr_reader(:event_codes)
      # @return [Array<Parameter>] Collection of {Parameter} objects
      attr_reader(:parameters)
      # @return [Array<Resource> Collection of {Resource} objects
      attr_reader(:resources)
      # @return [Array<Area>] Collection of {Area} objects
      attr_reader(:areas)

      # Initialises a new Info object which will be yielded to an attached block if given
      #
      # @return [RCAP::CAP_1_0::Info,RCAP::CAP_1_1::Info,RCAP::CAP_1_2::Info]
      def initialize
        @language       = DEFAULT_LANGUAGE
        @categories     = []
        @event_codes    = []
        @parameters     = []
        @resources      = []
        @areas          = []
        yield(self) if block_given?
      end

      # Creates a new EventCode object and adds it to the event_codes array.
      #
      # @return [EventCode]
      def add_event_code
        event_code = event_code_class.new
        yield(event_code) if block_given?
        @event_codes << event_code
        event_code
      end

      # Creates a new Parameter object and adds it to the parameters array.
      #
      # @return [Parameter]
      def add_parameter
        parameter = parameter_class.new
        yield(parameter) if block_given?
        @parameters << parameter
        parameter
      end

      # Creates a new Resource object and adds it to the resources array.
      #
      # @return [Resource]
      def add_resource
        resource = resource_class.new
        yield(resource) if block_given?
        @resources << resource
        resource
      end

      # Creates a new Area object and adds it to the areas array.
      #
      # @return [Area]
      def add_area
        area = area_class.new
        yield(area) if block_given?
        @areas << area
        area
      end

      # @return [REXML::Element]
      def to_xml_element
        xml_element = REXML::Element.new(XML_ELEMENT_NAME)
        xml_element.add_element(LANGUAGE_ELEMENT_NAME).add_text(@language.to_s) if @language
        @categories.each do |category|
          xml_element.add_element(CATEGORY_ELEMENT_NAME).add_text(category.to_s)
        end
        xml_element.add_element(EVENT_ELEMENT_NAME).add_text(@event.to_s)
        xml_element.add_element(URGENCY_ELEMENT_NAME).add_text(@urgency.to_s)
        xml_element.add_element(SEVERITY_ELEMENT_NAME).add_text(@severity.to_s)
        xml_element.add_element(CERTAINTY_ELEMENT_NAME).add_text(@certainty.to_s)
        xml_element.add_element(AUDIENCE_ELEMENT_NAME).add_text(@audience.to_s) if @audience
        @event_codes.each do |event_code|
          xml_element.add_element(event_code.to_xml_element)
        end
        xml_element.add_element(EFFECTIVE_ELEMENT_NAME).add_text(@effective.to_s_for_cap)      if @effective
        xml_element.add_element(ONSET_ELEMENT_NAME).add_text(@onset.to_s_for_cap)              if @onset
        xml_element.add_element(EXPIRES_ELEMENT_NAME).add_text(@expires.to_s_for_cap)          if @expires
        xml_element.add_element(SENDER_NAME_ELEMENT_NAME).add_text(@sender_name.to_s)          if @sender_name
        xml_element.add_element(HEADLINE_ELEMENT_NAME).add_text(@headline.to_s)                if @headline
        xml_element.add_element(DESCRIPTION_ELEMENT_NAME).add_text(@description.to_s)          if @description
        xml_element.add_element(INSTRUCTION_ELEMENT_NAME).add_text(@instruction.to_s)          if @instruction
        xml_element.add_element(WEB_ELEMENT_NAME).add_text(@web.to_s)                          if @web
        xml_element.add_element(CONTACT_ELEMENT_NAME).add_text(@contact.to_s)                  if @contact
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
        new do |info|
          info.language = RCAP.xpath_text(info_xml_element, LANGUAGE_XPATH, info.xmlns) || DEFAULT_LANGUAGE

          RCAP.xpath_match(info_xml_element, CATEGORY_XPATH, info.xmlns).each do |element|
            info.categories << element.text
          end

          info.event          = RCAP.xpath_text(info_xml_element, EVENT_XPATH, info.xmlns)
          info.urgency        = RCAP.xpath_text(info_xml_element, URGENCY_XPATH, info.xmlns)
          info.severity       = RCAP.xpath_text(info_xml_element, SEVERITY_XPATH, info.xmlns)
          info.certainty      = RCAP.xpath_text(info_xml_element, CERTAINTY_XPATH, info.xmlns)
          info.audience       = RCAP.xpath_text(info_xml_element, AUDIENCE_XPATH, info.xmlns)
          info.effective      = RCAP.parse_datetime(RCAP.xpath_text(info_xml_element, EFFECTIVE_XPATH, info.xmlns))
          info.onset          = RCAP.parse_datetime(RCAP.xpath_text(info_xml_element, ONSET_XPATH, info.xmlns))
          info.expires        = RCAP.parse_datetime(RCAP.xpath_text(info_xml_element, EXPIRES_XPATH, info.xmlns))
          info.sender_name    = RCAP.xpath_text(info_xml_element, SENDER_NAME_XPATH, info.xmlns)
          info.headline       = RCAP.xpath_text(info_xml_element, HEADLINE_XPATH, info.xmlns)
          info.description    = RCAP.xpath_text(info_xml_element, DESCRIPTION_XPATH, info.xmlns)
          info.instruction    = RCAP.xpath_text(info_xml_element, INSTRUCTION_XPATH, info.xmlns)
          info.web            = RCAP.xpath_text(info_xml_element, WEB_XPATH, info.xmlns)
          info.contact        = RCAP.xpath_text(info_xml_element, CONTACT_XPATH, info.xmlns)

          RCAP.xpath_match(info_xml_element, info.event_code_class::XPATH, info.xmlns).each do |element|
            info.event_codes << info.event_code_class.from_xml_element(element)
          end

          RCAP.xpath_match(info_xml_element, info.parameter_class::XPATH, info.xmlns).each do |element|
            info.parameters <<  info.parameter_class.from_xml_element(element)
          end

          RCAP.xpath_match(info_xml_element, info.resource_class::XPATH, info.xmlns).each do |element|
            info.resources << info.resource_class.from_xml_element(element)
          end

          RCAP.xpath_match(info_xml_element, info.area_class::XPATH, info.xmlns).each do |element|
            info.areas << info.area_class.from_xml_element(element)
          end
        end
      end

      # @return [String]
      def inspect
        info_inspect = "Language:       #{@language}\n"\
        "Categories:     #{@categories.to_s_for_cap}\n"\
        "Event:          #{@event}\n"\
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

      LANGUAGE_YAML       = 'Language'
      CATEGORIES_YAML     = 'Categories'
      EVENT_YAML          = 'Event'
      URGENCY_YAML        = 'Urgency'
      SEVERITY_YAML       = 'Severity'
      CERTAINTY_YAML      = 'Certainty'
      AUDIENCE_YAML       = 'Audience'
      EFFECTIVE_YAML      = 'Effective'
      ONSET_YAML          = 'Onset'
      EXPIRES_YAML        = 'Expires'
      SENDER_NAME_YAML    = 'Sender Name'
      HEADLINE_YAML       = 'Headline'
      DESCRIPTION_YAML    = 'Description'
      INSTRUCTION_YAML    = 'Instruction'
      WEB_YAML            = 'Web'
      CONTACT_YAML        = 'Contact'
      EVENT_CODES_YAML    = 'Event Codes'
      PARAMETERS_YAML     = 'Parameters'
      RESOURCES_YAML      = 'Resources'
      AREAS_YAML          = 'Areas'

      # @return [Hash]
      def to_yaml_data
        parameter_to_hash = ->(hash, parameter) { hash.merge(parameter.name => parameter.value) }

        RCAP.attribute_values_to_hash([LANGUAGE_YAML,       @language],
                                      [CATEGORIES_YAML,     @categories],
                                      [EVENT_YAML,          @event],
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
        new do |info|
          info.language = info_yaml_data [LANGUAGE_YAML]
          Array(info_yaml_data [CATEGORIES_YAML]).each do |category|
            info.categories << category
          end
          info.event       = RCAP.strip_if_given(info_yaml_data [EVENT_YAML])
          info.urgency     = RCAP.strip_if_given(info_yaml_data [URGENCY_YAML])
          info.severity    = RCAP.strip_if_given(info_yaml_data [SEVERITY_YAML])
          info.certainty   = RCAP.strip_if_given(info_yaml_data [CERTAINTY_YAML])
          info.audience    = RCAP.strip_if_given(info_yaml_data [AUDIENCE_YAML])
          info.effective   = RCAP.parse_datetime(info_yaml_data[EFFECTIVE_YAML])
          info.onset       = RCAP.parse_datetime(info_yaml_data[ONSET_YAML])
          info.expires     = RCAP.parse_datetime(info_yaml_data[EXPIRES_YAML])
          info.sender_name = RCAP.strip_if_given(info_yaml_data [SENDER_NAME_YAML])
          info.headline    = RCAP.strip_if_given(info_yaml_data [HEADLINE_YAML])
          info.description = RCAP.strip_if_given(info_yaml_data [DESCRIPTION_YAML])
          info.instruction = RCAP.strip_if_given(info_yaml_data [INSTRUCTION_YAML])
          info.web         = RCAP.strip_if_given(info_yaml_data [WEB_YAML])
          info.contact     = RCAP.strip_if_given(info_yaml_data [CONTACT_YAML])

          Array(info_yaml_data [EVENT_CODES_YAML]).each do |name, value|
            info.add_event_code do |event_code|
              event_code.name  = RCAP.strip_if_given(name)
              event_code.value = RCAP.strip_if_given(value)
            end
          end

          Array(info_yaml_data [PARAMETERS_YAML]).each do |name, value|
            info.add_parameter do |parameter|
              parameter.name  = RCAP.strip_if_given(name)
              parameter.value = RCAP.strip_if_given(value)
            end
          end

          Array(info_yaml_data [RESOURCES_YAML]).each do |resource_yaml_data|
            info.resources << info.resource_class.from_yaml_data(resource_yaml_data)
          end

          Array(info_yaml_data [AREAS_YAML]).each do |area_yaml_data|
            info.areas << info.area_class.from_yaml_data(area_yaml_data)
          end
        end
      end

      LANGUAGE_KEY       = 'language'
      CATEGORIES_KEY     = 'categories'
      EVENT_KEY          = 'event'
      URGENCY_KEY        = 'urgency'
      SEVERITY_KEY       = 'severity'
      CERTAINTY_KEY      = 'certainty'
      AUDIENCE_KEY       = 'audience'
      EFFECTIVE_KEY      = 'effective'
      ONSET_KEY          = 'onset'
      EXPIRES_KEY        = 'expires'
      SENDER_NAME_KEY    = 'sender_name'
      HEADLINE_KEY       = 'headline'
      DESCRIPTION_KEY    = 'description'
      INSTRUCTION_KEY    = 'instruction'
      WEB_KEY            = 'web'
      CONTACT_KEY        = 'contact'
      RESOURCES_KEY      = 'resources'
      EVENT_CODES_KEY    = 'event_codes'
      PARAMETERS_KEY     = 'parameters'
      AREAS_KEY          = 'areas'

      # @return [Hash]
      def to_h
        RCAP.attribute_values_to_hash([LANGUAGE_KEY, @language],
                                      [CATEGORIES_KEY,     @categories],
                                      [EVENT_KEY,          @event],
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
        new do |info|
          info.language = info_hash[LANGUAGE_KEY]
          Array(info_hash[CATEGORIES_KEY]).each do |category|
            info.categories << RCAP.strip_if_given(category)
          end
          info.event          = RCAP.strip_if_given(info_hash[EVENT_KEY])
          info.urgency        = RCAP.strip_if_given(info_hash[URGENCY_KEY])
          info.severity       = RCAP.strip_if_given(info_hash[SEVERITY_KEY])
          info.certainty      = RCAP.strip_if_given(info_hash[CERTAINTY_KEY])
          info.audience       = RCAP.strip_if_given(info_hash[AUDIENCE_KEY])
          info.effective      = RCAP.parse_datetime(info_hash[EFFECTIVE_KEY])
          info.onset          = RCAP.parse_datetime(info_hash[ONSET_KEY])
          info.expires        = RCAP.parse_datetime(info_hash[EXPIRES_KEY])
          info.sender_name    = RCAP.strip_if_given(info_hash[SENDER_NAME_KEY])
          info.headline       = RCAP.strip_if_given(info_hash[HEADLINE_KEY])
          info.description    = RCAP.strip_if_given(info_hash[DESCRIPTION_KEY])
          info.instruction    = RCAP.strip_if_given(info_hash[INSTRUCTION_KEY])
          info.web            = RCAP.strip_if_given(info_hash[WEB_KEY])
          info.contact        = RCAP.strip_if_given(info_hash[CONTACT_KEY])

          Array(info_hash[RESOURCES_KEY]).each do |resource_hash|
            info.resources << info.resource_class.from_h(resource_hash)
          end

          Array(info_hash[EVENT_CODES_KEY]).each do |event_code_hash|
            info.event_codes << info.event_code_class.from_h(event_code_hash)
          end

          Array(info_hash[PARAMETERS_KEY]).each do |parameter_hash|
            info.parameters << info.parameter_class.from_h(parameter_hash)
          end

          Array(info_hash[AREAS_KEY]).each do |area_hash|
            info.areas << info.area_class.from_h(area_hash)
          end
        end
      end

      def map_data?
        @areas.any?(&:map_data?)
      end
    end
  end
end
