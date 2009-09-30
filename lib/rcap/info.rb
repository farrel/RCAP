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

    OPTIONAL_ATOMIC_ELEMENTS = [ LANGUAGE, AUDIENCE, EFFECTIVE, ONSET, EXPIRES,
      SENDER_NAME, HEADLINE, DESCRIPTION, INSTRUCTION, WEB, CONTACT ]
    REQUIRED_ATOMIC_ELEMENTS = [ EVENT, URGENCY, SEVERITY, CERTAINTY ]

    OPTIONAL_GROUP_ELEMENTS  = [ RESPONSE_TYPES, EVENT_CODES, PARAMETERS ]
    REQUIRED_GROUP_ELEMENTS  = [ CATEGORIES ]

    attr_accessor( *( REQUIRED_ATOMIC_ELEMENTS + OPTIONAL_ATOMIC_ELEMENTS ))

    attr_reader( *( REQUIRED_GROUP_ELEMENTS + OPTIONAL_GROUP_ELEMENTS))

    validates_presence_of( *REQUIRED_ATOMIC_ELEMENTS )

    validates_length_of( REQUIRED_GROUP_ELEMENTS, :minimum => 1,
                        :message => 'requires at least one element' ) 

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

    validates_each( CATEGORIES ) do |info, attribute, categories|
      categories.each do |category|
        unless ALL_CATEGORIES.include?( category )
          info.errors[ attribute ] << "contains an invalid category: '#{ category }'" 
        end
      end
    end

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

    validates_each( RESPONSE_TYPES ) do |info, attribute, response_types|
      response_types.each do |response_type|
        unless ALL_RESPONSE_TYPES.include?( response_type )
          info.errors[ attribute ] << "contains an invalid response type: '#{ response_type }'" 
        end
      end
    end

    URGENCY_IMMEDIATE = "Immediate"
    URGENCY_EXPECTED  = "Expected"
    URGENCY_FUTURE    = "Future"
    URGENCY_PAST      = "Past"
    URGENCY_UNKNOWN   = "Unknown"
    ALL_URGENCIES = [ URGENCY_IMMEDIATE, URGENCY_EXPECTED, URGENCY_FUTURE,   
      URGENCY_PAST, URGENCY_UNKNOWN ]
    validates_each( URGENCY ) do |info, attribute, urgency |
      unless ALL_URGENCIES.include?( urgency )
        info.errors[ attribute ] << "is not a valid ugency code" 
      end
    end

    SEVERITY_EXTREME  = "Extreme"
    SEVERITY_SEVERE   = "Severe"
    SEVERITY_MODERATE = "Moderate"
    SEVERITY_MINOR    = "Minor"
    SEVERITY_UNKNOWN  = "Unknown"
    ALL_SEVERITIES = [ SEVERITY_EXTREME, SEVERITY_SEVERE, SEVERITY_MODERATE,
      SEVERITY_MINOR, SEVERITY_UNKNOWN ] 
    validates_each( SEVERITY ) do |info, attribute, severity|
      unless ALL_SEVERITIES.incllude?( severity )
        info.errors[ attribute ] << "is not a valid severity code"
      end
    end

    CERTAINTY_OBSERVED = "Observed"
    CERTAINTY_LIKELY   = "Likely"
    CERTAINTY_POSSIBLE = "Possible"
    CERTAINTY_UNLIKELY = "Unlikely"
    CERTAINTY_UNKNOWN  = "Unknown"
    ALL_CERTAINTIES = [ CERTAINTY_OBSERVED, CERTAINTY_LIKELY,
      CERTAINTY_POSSIBLE, CERTAINTY_UNLIKELY, CERTAINTY_UNKNOWN ]
    validates_each( CERTAINTY ) do |info, attribute, certainty|
      unless ALL_CERTAINTIES.incllude?( certainty )
        info.errors[ attribute ] << "is not a valid certainty code"
      end
    end

    def initialize( attributes = {} )
      @language       = attributes[ LANGUAGE ] || 'en-US'
      @categories     = []
      @event          = attributes [ EVENT ]
      @response_types = []
      @urgency        = attributes[ URGENCY ]
      @severity       = attributes[ SEVERITY ]
      @certainty      = attributes[ CERTAINTY ]
      @event_codes    = {}
      @sender_name    = attributes[ SENDER_NAME ]
      @headline       = attributes[ HEADLINE ]
      @description    = attributes[ DESCRIPTION ]
      @instruction    = attributes[ INSTRUCTION ]
      @web            = attributes[ WEB ]
      @contact        = attributes[ CONTACT ]
      @parameters     = {}
    end
  end
end
