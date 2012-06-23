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

      # Creates a new EventCode object and adds it to the event_codes array. The
      # event_code_attributes are passed as a parameter to EventCode.new.
      #
      # @see EventCode#initialize
      #
      # @param [Hash] event_code_attributes (see EventCode#initialize)
      # @return [EventCode]
      def add_event_code( event_code_attributes = {})
        event_code = EventCode.new( event_code_attributes )
        @event_codes << event_code
        event_code
      end

      # Creates a new Parameter object and adds it to the parameters array. The
      # parameter_attributes are passed as a parameter to Parameter.new.
      #
      # @see Parameter#initialize
      #
      # @param [Hash] parameter_attributes (see Parameter#initialize)
      # @return [Parameter]
      def add_parameter( parameter_attributes = {})
        parameter = Parameter.new( parameter_attributes )
        @parameters << parameter
        parameter
      end

      # Creates a new Resource object and adds it to the resources array. The
      # resource_attributes are passed as a parameter to Resource.new.
      #
      # @see Resource#initialize
      #
      # @param [Hash] resource_attributes (See Resource#initialize)
      # @return [Resource]
      def add_resource( resource_attributes = {})
        resource = Resource.new( resource_attributes )
        @resources << resource
        resource
      end

      # Creates a new Area object and adds it to the areas array. The
      # area_attributes are passed as a parameter to Area.new.
      #
      # @see Area#initialize
      #
      # @param [Hash] area_attributes (see Area#initialize)
      # @return [Area]
      def add_area( area_attributes = {})
        area = Area.new( area_attributes )
        @areas << area
        area
      end

      # @param [REXML::Element] info_xml_element
      # @return [Info]
      def self.from_xml_element( info_xml_element ) 
        self.new(
          :language       => RCAP.xpath_text( info_xml_element, LANGUAGE_XPATH, Alert::XMLNS ) || DEFAULT_LANGUAGE,
          :categories     => RCAP.xpath_match( info_xml_element, CATEGORY_XPATH, Alert::XMLNS ).map{ |element| element.text },
          :event          => RCAP.xpath_text( info_xml_element, EVENT_XPATH, Alert::XMLNS ),
          :urgency        => RCAP.xpath_text( info_xml_element, URGENCY_XPATH, Alert::XMLNS ),
          :severity       => RCAP.xpath_text( info_xml_element, SEVERITY_XPATH, Alert::XMLNS ),
          :certainty      => RCAP.xpath_text( info_xml_element, CERTAINTY_XPATH, Alert::XMLNS ),
          :audience       => RCAP.xpath_text( info_xml_element, AUDIENCE_XPATH, Alert::XMLNS ),
          :effective      => (( effective = RCAP.xpath_first( info_xml_element, EFFECTIVE_XPATH, Alert::XMLNS )) ? DateTime.parse( effective.text ) : nil ),
          :onset          => (( onset = RCAP.xpath_first( info_xml_element, ONSET_XPATH, Alert::XMLNS )) ? DateTime.parse( onset.text ) : nil ),
          :expires        => (( expires = RCAP.xpath_first( info_xml_element, EXPIRES_XPATH, Alert::XMLNS )) ? DateTime.parse( expires.text ) : nil ),
          :sender_name    => RCAP.xpath_text( info_xml_element, SENDER_NAME_XPATH, Alert::XMLNS ),
          :headline       => RCAP.xpath_text( info_xml_element, HEADLINE_XPATH, Alert::XMLNS ),
          :description    => RCAP.xpath_text( info_xml_element, DESCRIPTION_XPATH, Alert::XMLNS ),
          :instruction    => RCAP.xpath_text( info_xml_element, INSTRUCTION_XPATH, Alert::XMLNS ),
          :web            => RCAP.xpath_text( info_xml_element, WEB_XPATH, Alert::XMLNS ),
          :contact        => RCAP.xpath_text( info_xml_element, CONTACT_XPATH, Alert::XMLNS ),
          :event_codes    => RCAP.xpath_match( info_xml_element, EventCode::XPATH, Alert::XMLNS ).map{ |element| EventCode.from_xml_element( element )},
          :parameters     => RCAP.xpath_match( info_xml_element, Parameter::XPATH, Alert::XMLNS ).map{ |element| Parameter.from_xml_element( element )},
          :resources      => RCAP.xpath_match( info_xml_element, Resource::XPATH, Alert::XMLNS ).map{ |element| Resource.from_xml_element( element )},
          :areas          => RCAP.xpath_match( info_xml_element, Area::XPATH, Alert::XMLNS ).map{ |element| Area.from_xml_element( element )}
        )
      end

      # @param [Hash] info_yaml_data
      # @return [Info]
      def self.from_yaml_data( info_yaml_data ) 
        self.new(
          :language       => info_yaml_data [ LANGUAGE_YAML ],
          :categories     => info_yaml_data [ CATEGORIES_YAML ],
          :event          => info_yaml_data [ EVENT_YAML ],
          :urgency        => info_yaml_data [ URGENCY_YAML ],
          :severity       => info_yaml_data [ SEVERITY_YAML ],
          :certainty      => info_yaml_data [ CERTAINTY_YAML ],
          :audience       => info_yaml_data [ AUDIENCE_YAML ],
          :effective      => ( effective = info_yaml_data[ EFFECTIVE_YAML ]).blank? ? nil : DateTime.parse( effective.to_s ),
          :onset          => ( onset = info_yaml_data[ ONSET_YAML ]).blank? ? nil : DateTime.parse( onset.to_s ),
          :expires        => ( expires = info_yaml_data[ EXPIRES_YAML ]).blank? ? nil : DateTime.parse( expires.to_s ),
          :sender_name    => info_yaml_data [ SENDER_NAME_YAML ],
          :headline       => info_yaml_data [ HEADLINE_YAML ],
          :description    => info_yaml_data [ DESCRIPTION_YAML ],
          :instruction    => info_yaml_data [ INSTRUCTION_YAML ],
          :web            => info_yaml_data [ WEB_YAML ],
          :contact        => info_yaml_data [ CONTACT_YAML ],
          :event_codes    => Array( info_yaml_data [ EVENT_CODES_YAML ]).map{ |name,value| EventCode.new( :name => name, :value => value )},
          :parameters     => Array( info_yaml_data [ PARAMETERS_YAML ]).map{ |parameter_yaml_data| Parameter.new( :name => name, :value => value )},
          :resources      => Array( info_yaml_data [ RESOURCES_YAML ]).map{ |resource_yaml_data| Resource.from_yaml_data( resource_yaml_data )},
          :areas          => Array( info_yaml_data [ AREAS_YAML ]).map{ |area_yaml_data| Area.from_yaml_data( area_yaml_data )}
        )
      end

      # @param [Hash] info_hash
      # @return [Info]
      def self.from_h( info_hash ) 
        self.new( :language       => info_hash[ LANGUAGE_KEY ],
                 :categories     => info_hash[ CATEGORIES_KEY ],
                 :event          => info_hash[ EVENT_KEY ],
                 :urgency        => info_hash[ URGENCY_KEY ],
                 :severity       => info_hash[ SEVERITY_KEY ],
                 :certainty      => info_hash[ CERTAINTY_KEY ],
                 :audience       => info_hash[ AUDIENCE_KEY ],
                 :effective      => RCAP.parse_datetime( info_hash[ EFFECTIVE_KEY ]),
                 :onset          => RCAP.parse_datetime( info_hash[ ONSET_KEY ]),
                 :expires        => RCAP.parse_datetime( info_hash[ EXPIRES_KEY ]),
                 :sender_name    => info_hash[ SENDER_NAME_KEY ],
                 :headline       => info_hash[ HEADLINE_KEY ],
                 :description    => info_hash[ DESCRIPTION_KEY ],
                 :instruction    => info_hash[ INSTRUCTION_KEY ],
                 :web            => info_hash[ WEB_KEY ],
                 :contact        => info_hash[ CONTACT_KEY ],
                 :resources      => Array( info_hash[ RESOURCES_KEY ]).map{ |resource_hash| Resource.from_h( resource_hash ) },
                 :event_codes    => Array( info_hash[ EVENT_CODES_KEY ]).map{ |event_code_hash| EventCode.from_h( event_code_hash )},
                 :parameters     => Array( info_hash[ PARAMETERS_KEY ]).map{ |parameter_hash| Parameter.from_h( parameter_hash )},
                 :areas          => Array( info_hash[ AREAS_KEY ]).map{ |area_hash| Area.from_h( area_hash )})
      end
    end
  end
end
