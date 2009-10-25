module CAP
  class Info
    include Validation

    LANGUAGE       = :language
    EVENT          = :event
    URGENCY        = :urgency
    RESPONSE_TYPES = :response_types
    CATEGORIES     = :categories
    SEVERITY       = :severity
    CERTAINTY      = :certainty
    AUDIENCE       = :audience
    EVENT_CODES    = :event_codes
    EFFECTIVE      = :effective
    ONSET          = :onset
    EXPIRES        = :expires
    SENDER_NAME    = :sender_name
    HEADLINE       = :headline
    DESCRIPTION    = :description
    INSTRUCTION    = :instruction
    WEB            = :web
    CONTACT        = :contact
    PARAMETERS     = :parameters
    RESOURCES      = :resources
    AREAS          = :areas

    OPTIONAL_ATOMIC_ATTRIBUTES = [ LANGUAGE, AUDIENCE, EFFECTIVE, ONSET, EXPIRES,
      SENDER_NAME, HEADLINE, DESCRIPTION, INSTRUCTION, WEB, CONTACT ]
    REQUIRED_ATOMIC_ATTRIBUTES = [ EVENT, URGENCY, SEVERITY, CERTAINTY ]

    OPTIONAL_GROUP_ATTRIBUTES  = [ RESPONSE_TYPES, EVENT_CODES, PARAMETERS, RESOURCES, AREAS ]
    REQUIRED_GROUP_ATTRIBUTES  = [ CATEGORIES ]

    CATEGORY_GEO       = "Geo"
    CATEGORY_MET       = "Met"
    CATEGORY_SAFETY    = "Safety"
    CATEGORY_SECURITY  = "Security"
    CATEGORY_RESCUE    = "Rescue"
    CATEGORY_FIRE      = "Fire"
    CATEGORY_HEALTH    = "Health"
    CATEGORY_ENV       = "Env"
    CATEGORY_TRANSPORT = "Transport"
    CATEGORY_INFRA     = "Infra"
    CATEGORY_CBRNE     = "CBRNE"
    CATEGORY_OTHER     = "Other"
    ALL_CATEGORIES = [ CATEGORY_GEO, CATEGORY_MET, CATEGORY_SAFETY, 
      CATEGORY_SECURITY, CATEGORY_RESCUE,   CATEGORY_FIRE, CATEGORY_HEALTH,
      CATEGORY_ENV, CATEGORY_TRANSPORT, CATEGORY_INFRA, CATEGORY_CBRNE,
      CATEGORY_OTHER ]

    RESPONSE_TYPE_SHELTER  = "Shelter"
    RESPONSE_TYPE_EVACUATE = "Evacuate"
    RESPONSE_TYPE_PREPARE  = "Prepare"
    RESPONSE_TYPE_EXECUTE  = "Execute"
    RESPONSE_TYPE_MONITOR  = "Monitor"
    RESPONSE_TYPE_ASSESS   = "Assess"
    RESPONSE_TYPE_NONE     = "None"
    ALL_RESPONSE_TYPES = [ RESPONSE_TYPE_SHELTER, RESPONSE_TYPE_EVACUATE, 
      RESPONSE_TYPE_PREPARE, RESPONSE_TYPE_EXECUTE, RESPONSE_TYPE_MONITOR, 
      RESPONSE_TYPE_ASSESS, RESPONSE_TYPE_NONE ]

    URGENCY_IMMEDIATE = "Immediate"
    URGENCY_EXPECTED  = "Expected"
    URGENCY_FUTURE    = "Future"
    URGENCY_PAST      = "Past"
    URGENCY_UNKNOWN   = "Unknown"
    ALL_URGENCIES = [ URGENCY_IMMEDIATE, URGENCY_EXPECTED, URGENCY_FUTURE,   
      URGENCY_PAST, URGENCY_UNKNOWN ]

    SEVERITY_EXTREME  = "Extreme"
    SEVERITY_SEVERE   = "Severe"
    SEVERITY_MODERATE = "Moderate"
    SEVERITY_MINOR    = "Minor"
    SEVERITY_UNKNOWN  = "Unknown"
    ALL_SEVERITIES = [ SEVERITY_EXTREME, SEVERITY_SEVERE, SEVERITY_MODERATE,
      SEVERITY_MINOR, SEVERITY_UNKNOWN ] 

    CERTAINTY_OBSERVED = "Observed"
    CERTAINTY_LIKELY   = "Likely"
    CERTAINTY_POSSIBLE = "Possible"
    CERTAINTY_UNLIKELY = "Unlikely"
    CERTAINTY_UNKNOWN  = "Unknown"
    ALL_CERTAINTIES = [ CERTAINTY_OBSERVED, CERTAINTY_LIKELY,
      CERTAINTY_POSSIBLE, CERTAINTY_UNLIKELY, CERTAINTY_UNKNOWN ]
		
		XML_ELEMENT_NAME = 'info'
		LANGUAGE_ELEMENT_NAME = 'language'
		CATEGORY_ELEMENT_NAME = 'category'
		EVENT_ELEMENT_NAME = 'event'
		RESPONSE_TYPE_ELEMENT_NAME = 'responseType'
		URGENCY_ELEMENT_NAME = 'urgency'
		SEVERITY_ELEMENT_NAME = 'severity'
		CERTAINTY_ELEMENT_NAME = 'certainty'
		AUDIENCE_ELEMENT_NAME = 'audience'
		EVENT_CODE_ELEMENT_NAME = 'eventCode'
		EFFECTIVE_ELEMENT_NAME = 'effective'
		ONSET_ELEMENT_NAME = 'onset'
		EXPIRES_ELEMENT_NAME = 'expires'
		SENDER_NAME_ELEMENT_NAME = 'sernderName'
		HEADLINE_ELEMENT_NAME = 'headline'
		DESCRIPTION_ELEMENT_NAME = 'description'
		INSTRUCTION_ELEMENT_NAME = 'instruction'
		WEB_ELEMENT_NAME = 'web'
		CONTACT_ELEMENT_NAME = 'contact'

    XPATH = '/rcap:alert '+ "/cap:#{ XML_ELEMENT_NAME }"

    validates_presence_of( *REQUIRED_ATOMIC_ATTRIBUTES )
    validates_length_of( CATEGORIES, :minimum => 1 )
		validates_inclusion_of( CERTAINTY, :in => ALL_CERTAINTIES )
		validates_inclusion_of( SEVERITY, :in => ALL_SEVERITIES )
		validates_inclusion_of( URGENCY, :in => ALL_URGENCIES )
    validates_inclusion_of_members_of( RESPONSE_TYPES, :in => ALL_RESPONSE_TYPES, :allow_blank => true )
    validates_collection_of( RESOURCES, AREAS )

    attr_accessor( *( REQUIRED_ATOMIC_ATTRIBUTES + OPTIONAL_ATOMIC_ATTRIBUTES ))
    attr_reader( *( REQUIRED_GROUP_ATTRIBUTES + OPTIONAL_GROUP_ATTRIBUTES))
    
    def initialize( attributes = {} )
      @language       = attributes[ LANGUAGE ] || 'en-US'
      @categories     = Array( attributes[ CATEGORIES ])
      @event          = attributes [ EVENT ]
      @response_types = Array( attributes[ RESPONSE_TYPES ])
      @urgency        = attributes[ URGENCY ]
      @severity       = attributes[ SEVERITY ]
      @certainty      = attributes[ CERTAINTY ]
      @event_codes    = Array( attributes[ EVENT_CODES ])
      @sender_name    = attributes[ SENDER_NAME ]
      @headline       = attributes[ HEADLINE ]
      @description    = attributes[ DESCRIPTION ]
      @instruction    = attributes[ INSTRUCTION ]
      @web            = attributes[ WEB ]
      @contact        = attributes[ CONTACT ]
      @parameters     = Array( attributes[ PARAMETERS ])
      @resources      = Array( attributes[ RESOURCES ])
      @areas          = Array( attributes[ AREAS ])
    end

		def to_xml_element
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
				xml_element.add_lement( event_code.to_xml_element )
			end
			xml_element.add_element( EFFECTIVE_ELEMENT_NAME ).add_text( self.effective ) if self.effective
			xml_element.add_element( ONSET_ELEMENT_NAME ).add_text( self.onset ) if self.onset
			xml_element.add_element( EXPIRES_ELEMENT_NAME ).add_text( self.expires ) if self.expires
			xml_element.add_element( SENDER_NAME_ELEMENT_NAME ).add_text( self.sender_name ) if self.sender_name
			xml_element.add_element( HEADLINE_ELEMENT_NAME ).add_text( self.headline ) if self.headline
			xml_element.add_element( DESCRIPTION_ELEMENT_NAME ).add_text( self.description ) if self.description
			xml_element.add_element( INSTRUCTION_ELEMENT_NAME ).add_text( self.instruction ) if self.instruction
			xml_element.add_element( WEB_ELEMENT_NAME ).add_text( self.web ) if self.web
			xml_element.add_element( CONTACT_ELEMENT_NAME ).add_text( self.contact ) if self.contact
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

		def to_xml
			self.to_xml_element.to_s
		end
  end
end
