module CAP
  class Info
    include Validation

    OPTIONAL_ATOMIC_ELEMENTS = [ :language, :audience, :effective, :onset,
      :expires, :sender_name, :headline, :description, :instruction,
      :web, :contact ]
    OPTIONAL_GROUP_ELEMENTS = [ :response_types, :event_codes, :parameters ]

    REQUIRED_ATOMIC_ELEMENTS = [ :event, :urgency, :severity, :certainty ]
    REQUIRED_GROUP_ELEMENTS = [ :categories ]

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
    ALL_CATEGORIES =    [ CATEGORY_GEO, CATEGORY_MET, CATEGORY_SAFETY, 
      CATEGORY_SECURITY, CATEGORY_RESCUE,   CATEGORY_FIRE, CATEGORY_HEALTH,
      CATEGORY_ENV, CATEGORY_TRANSPORT, CATEGORY_INFRA, CATEGORY_CBRNE,
      CATEGORY_OTHER ]
    
    validates_each( :categories ) do |info, attribute, categories|
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

    validates_each( :response_types ) do |info, attribute, response_types|
      response_types.each do |response_type|
        unless ALL_CATEGORIES.include?( response_type )
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
    validates_each( :urgency ) do |info, attribute, urgency |
      unless ALL_URGENCIES.include?( urgency )
        info.errors[ attribute ] << 'is not a valid urgency' 
      end
    end

    SEVERITY_EXTREME  = "Extreme"
    SEVERITY_SEVERE   = "Severe"
    SEVERITY_MODERATE = "Moderate"
    SEVERITY_UNKNOWN  = "Unknown"
     ALL_SEVERITIES = [ SEVERITY_EXTREME, SEVERITY_SEVERE,  SEVERITY_MODERATE,
       SEVERITY_UNKNOWN ] 
     validates_each( :severity ) do |info, attribute, severity|
       unless ALL_SEVERITIES.include?( severity )
         info.errors[ attribute ] << 'is not a valid severity'
       end
     end

     CERTAINTY_OBSERVED = "Observed"
     CERTAINTY_LIKELY   = "Likely"
     CERTAINTY_POSSIBLE = "Possible"
     CERTAINTY_UNLIKELY = "Unlikely"
     CERTAINTY_UNKNOWN  = "Unknown"
     ALL_CERTAINTIES = [ CERTAINTY_OBSERVED, CERTAINTY_LIKELY,
       CERTAINTY_POSSIBLE, CERTAINTY_UNLIKELY, CERTAINTY_UNKNOWN ] 
     validates_each( :certainty ) do |info, attribute, certainty|
       unless ALL_CERTAINTIES.include?( certainty )
         info.errors[ attribute ] << 'is not a valid certainty'
       end
     end

    def initialize( attributes = {} )
      @language = attributes[ :language ] || 'en-US'
      @categories = []
      @event = attributes [ :event ]
      @response_types = []
      @urgency = attributes[ :urgency ]
      @audience = attributes[ :audience ]
      @event_codes = {}
      @parameters = {}
    end
  end
end
