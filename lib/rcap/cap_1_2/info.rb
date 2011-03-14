module RCAP
  module CAP_1_2
    # In Info object is valid if
    # * it has an event
    # * it has an urgency with a valid value
    # * it has a severity with a valid value
    # * it has a certainty with a valid value
    # * all categories are valid and categories has at minimum 1 entry
    # * all Resource objects in the resources collection are valid
    # * all Area objects in the areas collection are valid
    class Info
      include Validation

      CATEGORY_GEO       = "Geo"       # :nodoc:
      CATEGORY_MET       = "Met"       # :nodoc:
      CATEGORY_SAFETY    = "Safety"    # :nodoc:
      CATEGORY_SECURITY  = "Security"  # :nodoc:
      CATEGORY_RESCUE    = "Rescue"    # :nodoc:
      CATEGORY_FIRE      = "Fire"      # :nodoc:
      CATEGORY_HEALTH    = "Health"    # :nodoc:
      CATEGORY_ENV       = "Env"       # :nodoc:
      CATEGORY_TRANSPORT = "Transport" # :nodoc:
      CATEGORY_INFRA     = "Infra"     # :nodoc:
      CATEGORY_CBRNE     = "CBRNE"     # :nodoc:
      CATEGORY_OTHER     = "Other"     # :nodoc:
      # Valid values for categories
      VALID_CATEGORIES = [ CATEGORY_GEO, CATEGORY_MET, CATEGORY_SAFETY,  
        CATEGORY_SECURITY, CATEGORY_RESCUE,   CATEGORY_FIRE, CATEGORY_HEALTH,
        CATEGORY_ENV, CATEGORY_TRANSPORT, CATEGORY_INFRA, CATEGORY_CBRNE,
        CATEGORY_OTHER ]

      RESPONSE_TYPE_SHELTER  = "Shelter"  # :nodoc:
      RESPONSE_TYPE_EVACUATE = "Evacuate" # :nodoc:
      RESPONSE_TYPE_PREPARE  = "Prepare"  # :nodoc:
      RESPONSE_TYPE_EXECUTE  = "Execute"  # :nodoc:
      RESPONSE_TYPE_MONITOR  = "Monitor"  # :nodoc:
      RESPONSE_TYPE_ASSESS   = "Assess"   # :nodoc:
      RESPONSE_TYPE_NONE     = "None"     # :nodoc:
      # Valid values for response_type
      VALID_RESPONSE_TYPES = [ RESPONSE_TYPE_SHELTER, RESPONSE_TYPE_EVACUATE, 
        RESPONSE_TYPE_PREPARE, RESPONSE_TYPE_EXECUTE, RESPONSE_TYPE_MONITOR, 
        RESPONSE_TYPE_ASSESS, RESPONSE_TYPE_NONE ]

      URGENCY_IMMEDIATE = "Immediate" # :nodoc:
      URGENCY_EXPECTED  = "Expected"  # :nodoc:
      URGENCY_FUTURE    = "Future"    # :nodoc:
      URGENCY_PAST      = "Past"      # :nodoc:
      URGENCY_UNKNOWN   = "Unknown"   # :nodoc:
      # Valid values for urgency
      VALID_URGENCIES = [ URGENCY_IMMEDIATE, URGENCY_EXPECTED, URGENCY_FUTURE,   
        URGENCY_PAST, URGENCY_UNKNOWN ]

      SEVERITY_EXTREME  = "Extreme"  # :nodoc:
      SEVERITY_SEVERE   = "Severe"   # :nodoc:
      SEVERITY_MODERATE = "Moderate" # :nodoc:
      SEVERITY_MINOR    = "Minor"    # :nodoc:
      SEVERITY_UNKNOWN  = "Unknown"  # :nodoc:
      # Valid values for severity
      VALID_SEVERITIES = [ SEVERITY_EXTREME, SEVERITY_SEVERE, SEVERITY_MODERATE,
        SEVERITY_MINOR, SEVERITY_UNKNOWN ] 

      CERTAINTY_OBSERVED = "Observed" # :nodoc:
      CERTAINTY_LIKELY   = "Likely"   # :nodoc:
      CERTAINTY_POSSIBLE = "Possible" # :nodoc:
      CERTAINTY_UNLIKELY = "Unlikely" # :nodoc:
      CERTAINTY_UNKNOWN  = "Unknown"  # :nodoc:
      # Valid valies for certainty
      VALID_CERTAINTIES = [ CERTAINTY_OBSERVED, CERTAINTY_LIKELY,
        CERTAINTY_POSSIBLE, CERTAINTY_UNLIKELY, CERTAINTY_UNKNOWN ]

      XML_ELEMENT_NAME           = 'info'         # :nodoc:
      LANGUAGE_ELEMENT_NAME      = 'language'     # :nodoc:
      CATEGORY_ELEMENT_NAME      = 'category'     # :nodoc:
      EVENT_ELEMENT_NAME         = 'event'        # :nodoc:
      RESPONSE_TYPE_ELEMENT_NAME = 'responseType' # :nodoc:
      URGENCY_ELEMENT_NAME       = 'urgency'      # :nodoc:
      SEVERITY_ELEMENT_NAME      = 'severity'     # :nodoc:
      CERTAINTY_ELEMENT_NAME     = 'certainty'    # :nodoc:
      AUDIENCE_ELEMENT_NAME      = 'audience'     # :nodoc:
      EVENT_CODE_ELEMENT_NAME    = 'eventCode'    # :nodoc:
      EFFECTIVE_ELEMENT_NAME     = 'effective'    # :nodoc:
      ONSET_ELEMENT_NAME         = 'onset'        # :nodoc:
      EXPIRES_ELEMENT_NAME       = 'expires'      # :nodoc:
      SENDER_NAME_ELEMENT_NAME   = 'sernderName'  # :nodoc:
      HEADLINE_ELEMENT_NAME      = 'headline'     # :nodoc:
      DESCRIPTION_ELEMENT_NAME   = 'description'  # :nodoc:
      INSTRUCTION_ELEMENT_NAME   = 'instruction'  # :nodoc:
      WEB_ELEMENT_NAME           = 'web'          # :nodoc:
      CONTACT_ELEMENT_NAME       = 'contact'      # :nodoc:

      XPATH               = "cap:#{ XML_ELEMENT_NAME }"           # :nodoc: 
      LANGUAGE_XPATH      = "cap:#{ LANGUAGE_ELEMENT_NAME }"      # :nodoc: 
      EVENT_XPATH         = "cap:#{ EVENT_ELEMENT_NAME }"         # :nodoc: 
      URGENCY_XPATH       = "cap:#{ URGENCY_ELEMENT_NAME }"       # :nodoc: 
      RESPONSE_TYPE_XPATH = "cap:#{ RESPONSE_TYPE_ELEMENT_NAME }" # :nodoc: 
      CATEGORY_XPATH      = "cap:#{ CATEGORY_ELEMENT_NAME }"      # :nodoc: 
      SEVERITY_XPATH      = "cap:#{ SEVERITY_ELEMENT_NAME }"      # :nodoc: 
      CERTAINTY_XPATH     = "cap:#{ CERTAINTY_ELEMENT_NAME }"     # :nodoc: 
      AUDIENCE_XPATH      = "cap:#{ AUDIENCE_ELEMENT_NAME }"      # :nodoc: 
      EVENT_CODE_XPATH    = "cap:#{ EVENT_CODE_ELEMENT_NAME }"    # :nodoc: 
      EFFECTIVE_XPATH     = "cap:#{ EFFECTIVE_ELEMENT_NAME }"     # :nodoc: 
      ONSET_XPATH         = "cap:#{ ONSET_ELEMENT_NAME }"         # :nodoc: 
      EXPIRES_XPATH       = "cap:#{ EXPIRES_ELEMENT_NAME }"       # :nodoc: 
      SENDER_NAME_XPATH   = "cap:#{ SENDER_NAME_ELEMENT_NAME }"   # :nodoc: 
      HEADLINE_XPATH      = "cap:#{ HEADLINE_ELEMENT_NAME }"      # :nodoc: 
      DESCRIPTION_XPATH   = "cap:#{ DESCRIPTION_ELEMENT_NAME }"   # :nodoc: 
      INSTRUCTION_XPATH   = "cap:#{ INSTRUCTION_ELEMENT_NAME }"   # :nodoc: 
      WEB_XPATH           = "cap:#{ WEB_ELEMENT_NAME }"           # :nodoc: 
      CONTACT_XPATH       = "cap:#{ CONTACT_ELEMENT_NAME }"       # :nodoc: 

      DEFAULT_LANGUAGE = 'en-US'

      validates_presence_of( :event, :urgency, :severity, :certainty )
      validates_length_of( :categories, :minimum => 1 )
      validates_inclusion_of( :certainty, :allow_nil => true, :in => VALID_CERTAINTIES, :message => "can only be assigned the following values: #{ VALID_CERTAINTIES.join(', ') }")
      validates_inclusion_of( :severity, :allow_nil  => true, :in => VALID_SEVERITIES,  :message => "can only be assigned the following values: #{ VALID_SEVERITIES.join(', ') }" )
      validates_inclusion_of( :urgency, :allow_nil   => true, :in => VALID_URGENCIES,   :message => "can only be assigned the following values: #{ VALID_URGENCIES.join(', ') }" )
      validates_inclusion_of_members_of( :response_types, :in  => VALID_RESPONSE_TYPES, :allow_blank => true )
      validates_inclusion_of_members_of( :categories,     :in  => VALID_CATEGORIES,     :allow_blank => true )
      validates_collection_of( :resources, :areas )

      attr_accessor( :event )
      # Value can only be one of VALID_URGENCIES
      attr_accessor( :urgency )
      # Value can only be one of VALID_SEVERITIES
      attr_accessor( :severity )
      # Value can only be one of VALID_CERTAINTIES
      attr_accessor( :certainty )
      attr_accessor( :language )
      attr_accessor( :audience )
      # Effective start time of information
      attr_accessor( :effective )
      # Expected start of event
      attr_accessor( :onset )
      # Effective expiry time of information
      attr_accessor( :expires )
      attr_accessor( :sender_name )
      attr_accessor( :headline )
      attr_accessor( :description )
      attr_accessor( :instruction )
      attr_accessor( :web )
      attr_accessor( :contact )

      # Collection of textual categories; elements can be one of VALID_CATEGORIES
      attr_reader( :categories )
      #  Collection of textual response types
      attr_reader( :response_types )
      # Collectoin of EventCode objects
      attr_reader( :event_codes )
      # Collection of Parameter objects
      attr_reader( :parameters )
      # Collection of Resource objects
      attr_reader( :resources )
      # Collection of Area objects
      attr_reader( :areas )

      def initialize( attributes = {} )
        @language       = attributes[ :language ] || DEFAULT_LANGUAGE
        @categories     = Array( attributes[ :categories ])
        @event          = attributes [ :event ]
        @response_types = Array( attributes[ :response_types ])
        @urgency        = attributes[ :urgency ]
        @severity       = attributes[ :severity ]
        @certainty      = attributes[ :certainty ]
        @effective      = attributes[ :effective ]
        @onset          = attributes[ :onset ]
        @expires        = attributes[ :expires ]
        @event_codes    = Array( attributes[ :event_codes ])
        @sender_name    = attributes[ :sender_name ]
        @headline       = attributes[ :headline ]
        @description    = attributes[ :description ]
        @instruction    = attributes[ :instruction ]
        @web            = attributes[ :web ]
        @contact        = attributes[ :contact ]
        @parameters     = Array( attributes[ :parameters ])
        @resources      = Array( attributes[ :resources ])
        @areas          = Array( attributes[ :areas ])
      end

      def to_xml_element # :nodoc:
        xml_element = REXML::Element.new( XML_ELEMENT_NAME )
        xml_element.add_element( LANGUAGE_ELEMENT_NAME ).add_text( self.language ) if self.language
        @categories.each do |category|
          xml_element.add_element( CATEGORY_ELEMENT_NAME ).add_text( category )
        end
        xml_element.add_element( EVENT_ELEMENT_NAME ).add_text( self.event )
        @response_types.each do |response_type|
          xml_element.add_element( RESPONSE_TYPE_ELEMENT_NAME ).add_text( response_type )
        end
        xml_element.add_element( URGENCY_ELEMENT_NAME ).add_text( self.urgency )
        xml_element.add_element( SEVERITY_ELEMENT_NAME ).add_text( self.severity )
        xml_element.add_element( CERTAINTY_ELEMENT_NAME ).add_text( self.certainty )
        xml_element.add_element( AUDIENCE_ELEMENT_NAME ).add_text( self.audience ) if self.audience
        @event_codes.each do |event_code|
          xml_element.add_element( event_code.to_xml_element )
        end
        xml_element.add_element( EFFECTIVE_ELEMENT_NAME ).add_text( self.effective.to_s_for_cap ) if self.effective
        xml_element.add_element( ONSET_ELEMENT_NAME ).add_text( self.onset.to_s_for_cap )         if self.onset
        xml_element.add_element( EXPIRES_ELEMENT_NAME ).add_text( self.expires.to_s_for_cap )     if self.expires
        xml_element.add_element( SENDER_NAME_ELEMENT_NAME ).add_text( self.sender_name )          if self.sender_name
        xml_element.add_element( HEADLINE_ELEMENT_NAME ).add_text( self.headline )                if self.headline
        xml_element.add_element( DESCRIPTION_ELEMENT_NAME ).add_text( self.description )          if self.description
        xml_element.add_element( INSTRUCTION_ELEMENT_NAME ).add_text( self.instruction )          if self.instruction
        xml_element.add_element( WEB_ELEMENT_NAME ).add_text( self.web )                          if self.web
        xml_element.add_element( CONTACT_ELEMENT_NAME ).add_text( self.contact )                  if self.contact
        @parameters.each do |parameter|
          xml_element.add_element( parameter.to_xml_element )
        end
        @resources.each do |resource|
          xml_element.add_element( resource.to_xml_element )
        end
        @areas.each do |area|
          xml_element.add_element( area.to_xml_element )
        end
        xml_element
      end

      def to_xml # :nodoc:
        self.to_xml_element.to_s
      end

      def inspect # :nodoc:
        info_inspect = <<EOF
Language:       #{ self.language }
Categories:     #{ self.categories.to_s_for_cap }
Event:          #{ self.event }
Response Types: #{ self.response_types.to_s_for_cap }
Urgency:        #{ self.urgency }
Severity:       #{ self.severity }
Certainty:      #{ self.certainty }
Audience:       #{ self.audience }
Event Codes:    #{ self.event_codes.inspect }
Effective:      #{ self.effective }
Onset:          #{ self.onset }
Expires:        #{ self.expires }
Sender Name:    #{ self.sender_name }
Headline:       #{ self.headline }
Description:
#{ self.description.to_s.lines.map{ |line| "  " + line }.join }
Instruction:    #{ self.instruction }
Web:            #{ self.web }
Contact:        #{ self.contact }
Parameters:
#{ self.parameters.map{ |parameter| parameter.inspect }.join( "\n" )}
Resources:
#{ self.resources.map{ |resource| "  " + resource.inspect }.join( "\n" )}
Area:
#{ self.areas.map{ |area| "  #{ area }" }.join( "\n" )}
EOF
RCAP.format_lines_for_inspect( 'INFO', info_inspect )
      end

      # Returns a string representation of the event of the form
      #  event(urgency/severity/certainty)
      def to_s 
        "#{ self.event }(#{ self.urgency }/#{ self.severity }/#{ self.certainty })"
      end

      def self.from_xml_element( info_xml_element ) # :nodoc:
        self.new(
          :language       => RCAP.xpath_text( info_xml_element, LANGUAGE_XPATH, Alert::XMLNS ) || DEFAULT_LANGUAGE,
          :categories     => RCAP.xpath_match( info_xml_element, CATEGORY_XPATH, Alert::XMLNS ).map{ |element| element.text },
          :event          => RCAP.xpath_text( info_xml_element, EVENT_XPATH, Alert::XMLNS ),
          :response_types => RCAP.xpath_match( info_xml_element, RESPONSE_TYPE_XPATH, Alert::XMLNS ).map{ |element| element.text },
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

      LANGUAGE_YAML       = 'Language'       # :nodoc:
      CATEGORIES_YAML     = 'Categories'     # :nodoc:
      EVENT_YAML          = 'Event'          # :nodoc:
      RESPONSE_TYPES_YAML = 'Response Types' # :nodoc:
      URGENCY_YAML        = 'Urgency'        # :nodoc:
      SEVERITY_YAML       = 'Severity'       # :nodoc:
      CERTAINTY_YAML      = 'Certainty'      # :nodoc:
      AUDIENCE_YAML       = 'Audience'       # :nodoc:
      EFFECTIVE_YAML      = 'Effective'      # :nodoc:
      ONSET_YAML          = 'Onset'          # :nodoc:
      EXPIRES_YAML        = 'Expires'        # :nodoc:
      SENDER_NAME_YAML    = 'Sender Name'    # :nodoc:
      HEADLINE_YAML       = 'Headline'       # :nodoc:
      DESCRIPTION_YAML    = 'Description'    # :nodoc:
      INSTRUCTION_YAML    = 'Instruction'    # :nodoc:
      WEB_YAML            = 'Web'            # :nodoc:
      CONTACT_YAML        = 'Contact'        # :nodoc:
      EVENT_CODES_YAML    = 'Event Codes'    # :nodoc:
      PARAMETERS_YAML     = 'Parameters'     # :nodoc:
      RESOURCES_YAML      = 'Resources'      # :nodoc:
      AREAS_YAML          = 'Areas'          # :nodoc:

      def to_yaml( options = {} ) # :nodoc:
        response_types_yaml = self.response_types
        def response_types_yaml.to_yaml_style; :inline; end

        categories_yaml = self.categories
        def categories_yaml.to_yaml_style; :inline; end

        parameter_to_hash = lambda{ |hash, parameter| hash.merge( parameter.name => parameter.value )}

        RCAP.attribute_values_to_hash( 
                                      [ LANGUAGE_YAML,       self.language ],
                                      [ CATEGORIES_YAML,     categories_yaml ],
                                      [ EVENT_YAML,          self.event ],
                                      [ RESPONSE_TYPES_YAML, response_types_yaml ],
                                      [ URGENCY_YAML,        self.urgency ],
                                      [ SEVERITY_YAML,       self.severity ],
                                      [ CERTAINTY_YAML,      self.certainty ],
                                      [ AUDIENCE_YAML,       self.audience ],
                                      [ EFFECTIVE_YAML,      self.effective ],
                                      [ ONSET_YAML,          self.onset ],
                                      [ EXPIRES_YAML,        self.expires ],
                                      [ SENDER_NAME_YAML,    self.sender_name ],
                                      [ HEADLINE_YAML,       self.headline ],
                                      [ DESCRIPTION_YAML,    self.description ],
                                      [ INSTRUCTION_YAML,    self.instruction ],
                                      [ WEB_YAML,            self.web ],
                                      [ CONTACT_YAML,        self.contact ],
                                      [ EVENT_CODES_YAML,    self.event_codes.inject({}, &parameter_to_hash )],
                                      [ PARAMETERS_YAML,     self.parameters.inject({}, &parameter_to_hash )],
                                      [ RESOURCES_YAML,      self.resources ],
                                      [ AREAS_YAML,          self.areas ]
                                     ).to_yaml( options )
      end

      def self.from_yaml_data( info_yaml_data ) # :nodoc:
        self.new(
          :language       => info_yaml_data [ LANGUAGE_YAML ],
          :categories     => info_yaml_data [ CATEGORIES_YAML ],
          :event          => info_yaml_data [ EVENT_YAML ],
          :response_types => info_yaml_data [ RESPONSE_TYPES_YAML ],
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

      LANGUAGE_KEY       = 'language'       # :nodoc:      
      CATEGORIES_KEY     = 'categories'     # :nodoc:    
      EVENT_KEY          = 'event'          # :nodoc:         
      RESPONSE_TYPES_KEY = 'response_types' # :nodoc:
      URGENCY_KEY        = 'urgency'        # :nodoc:       
      SEVERITY_KEY       = 'severity'       # :nodoc:      
      CERTAINTY_KEY      = 'certainty'      # :nodoc:     
      AUDIENCE_KEY       = 'audience'       # :nodoc:
      EFFECTIVE_KEY      = 'effective'      # :nodoc:     
      ONSET_KEY          = 'onset'          # :nodoc:         
      EXPIRES_KEY        = 'expires'        # :nodoc:       
      SENDER_NAME_KEY    = 'sender_name'    # :nodoc:   
      HEADLINE_KEY       = 'headline'       # :nodoc:      
      DESCRIPTION_KEY    = 'description'    # :nodoc:   
      INSTRUCTION_KEY    = 'instruction'    # :nodoc:   
      WEB_KEY            = 'web'            # :nodoc:           
      CONTACT_KEY        = 'contact'        # :nodoc:       
      RESOURCES_KEY      = 'resources'      # :nodoc:     
      EVENT_CODES_KEY    = 'event_codes'    # :nodoc:   
      PARAMETERS_KEY     = 'parameters'     # :nodoc:    
      AREAS_KEY          = 'areas'          # :nodoc:         

      def to_h # :nodoc:
        RCAP.attribute_values_to_hash( [ LANGUAGE_KEY,       self.language ],
                                      [ CATEGORIES_KEY,     self.categories ],
                                      [ EVENT_KEY,          self.event ],
                                      [ RESPONSE_TYPES_KEY, self.response_types ],
                                      [ URGENCY_KEY,        self.urgency ],
                                      [ SEVERITY_KEY,       self.severity ],
                                      [ CERTAINTY_KEY,      self.certainty ],
                                      [ AUDIENCE_KEY,       self.audience ],
                                      [ EFFECTIVE_KEY,      RCAP.to_s_for_cap( self.effective )],
                                      [ ONSET_KEY,          RCAP.to_s_for_cap( self.onset )],
                                      [ EXPIRES_KEY,        RCAP.to_s_for_cap( self.expires )],
                                      [ SENDER_NAME_KEY,    self.sender_name ],
                                      [ HEADLINE_KEY,       self.headline ],
                                      [ DESCRIPTION_KEY,    self.description ],
                                      [ INSTRUCTION_KEY,    self.instruction ],
                                      [ WEB_KEY,            self.web ],
                                      [ CONTACT_KEY,        self.contact ],
                                      [ RESOURCES_KEY,      self.resources.map{ |resource| resource.to_h } ],
                                      [ EVENT_CODES_KEY,    self.event_codes.map{ |event_code| event_code.to_h } ],
                                      [ PARAMETERS_KEY,     self.parameters.map{ |parameter| parameter.to_h } ],
                                      [ AREAS_KEY,          self.areas.map{ |area| area.to_h }])
      end

      def self.from_h( info_hash ) # :nodoc:
        self.new( :language       => info_hash[ LANGUAGE_KEY ],
                 :categories     => info_hash[ CATEGORIES_KEY ],
                 :event          => info_hash[ EVENT_KEY ],
                 :response_types => info_hash[ RESPONSE_TYPES_KEY ],
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
