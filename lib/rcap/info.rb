module CAP
  class Info
    include Validation

    LANGUAGE       = :language
    EVENT          = :event
    URGENCY        = :urgency
    RESPONSE_TYPES = :response_types
    CATEGORIES     = :categories

    OPTIONAL_ATOMIC_ELEMENTS = [ LANGUAGE ]
    REQUIRED_ATOMIC_ELEMENTS = [ EVENT, URGENCY ]
    OPTIONAL_GROUP_ELEMENTS  = [ RESPONSE_TYPES ]
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


    def initialize( attributes = {} )
      @language = attributes[ LANGUAGE ] || 'en-US'
      @categories = []
      @event = attributes [ EVENT ]
      @response_types = []
      @urgency = attributes[ URGENCY ]
    end
  end
end
