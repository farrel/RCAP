module CAP
  class Info
    include Validation

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
      CATEGORY_OTHER ] # :nodoc:

    RESPONSE_TYPE_SHELTER  = "Shelter"
    RESPONSE_TYPE_EVACUATE = "Evacuate"
    RESPONSE_TYPE_PREPARE  = "Prepare"
    RESPONSE_TYPE_EXECUTE  = "Execute"
    RESPONSE_TYPE_MONITOR  = "Monitor"
    RESPONSE_TYPE_ASSESS   = "Assess"
    RESPONSE_TYPE_NONE     = "None"
    ALL_RESPONSE_TYPES = [ RESPONSE_TYPE_SHELTER, RESPONSE_TYPE_EVACUATE, 
      RESPONSE_TYPE_PREPARE, RESPONSE_TYPE_EXECUTE, RESPONSE_TYPE_MONITOR, 
      RESPONSE_TYPE_ASSESS, RESPONSE_TYPE_NONE ] # :nodoc:

    URGENCY_IMMEDIATE = "Immediate"
    URGENCY_EXPECTED  = "Expected"
    URGENCY_FUTURE    = "Future"
    URGENCY_PAST      = "Past"
    URGENCY_UNKNOWN   = "Unknown"
    ALL_URGENCIES = [ URGENCY_IMMEDIATE, URGENCY_EXPECTED, URGENCY_FUTURE,   
      URGENCY_PAST, URGENCY_UNKNOWN ] # :nodoc:

    SEVERITY_EXTREME  = "Extreme"
    SEVERITY_SEVERE   = "Severe"
    SEVERITY_MODERATE = "Moderate"
    SEVERITY_MINOR    = "Minor"
    SEVERITY_UNKNOWN  = "Unknown"
    ALL_SEVERITIES = [ SEVERITY_EXTREME, SEVERITY_SEVERE, SEVERITY_MODERATE,
      SEVERITY_MINOR, SEVERITY_UNKNOWN ] # :nodoc: 

    CERTAINTY_OBSERVED = "Observed"
    CERTAINTY_LIKELY   = "Likely"
    CERTAINTY_POSSIBLE = "Possible"
    CERTAINTY_UNLIKELY = "Unlikely"
    CERTAINTY_UNKNOWN  = "Unknown"
    ALL_CERTAINTIES = [ CERTAINTY_OBSERVED, CERTAINTY_LIKELY,
      CERTAINTY_POSSIBLE, CERTAINTY_UNLIKELY, CERTAINTY_UNKNOWN ] # :nodoc:

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
    validates_inclusion_of( :certainty, :allow_nil => true, :in => ALL_CERTAINTIES, :message => "can only be assigned the following values: #{ ALL_CERTAINTIES.join(', ') }")
    validates_inclusion_of( :severity, :allow_nil  => true, :in => ALL_SEVERITIES, :message  => "can only be assigned the following values: #{ ALL_SEVERITIES.join(', ') }" )
    validates_inclusion_of( :urgency, :allow_nil   => true, :in => ALL_URGENCIES, :message   => "can only be assigned the following values: #{ ALL_URGENCIES.join(', ') }" )
    validates_inclusion_of_members_of( :response_types, :in => ALL_RESPONSE_TYPES, :allow_blank => true )
    validates_collection_of( :resources, :areas )

    attr_accessor( :event, :urgency, :severity, :certainty, :language, :audience, :effective, :onset, :expires, :sender_name, :headline, :description, :instruction, :web, :contact )
    attr_reader( :categories, :response_types, :event_codes, :parameters, :resources, :areas )

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
        xml_element.add_element( event_code.to_xml_element )
      end
      xml_element.add_element( EFFECTIVE_ELEMENT_NAME ).add_text( self.effective.to_s ) if self.effective
      xml_element.add_element( ONSET_ELEMENT_NAME ).add_text( self.onset.to_s )         if self.onset
      xml_element.add_element( EXPIRES_ELEMENT_NAME ).add_text( self.expires.to_s )     if self.expires
      xml_element.add_element( SENDER_NAME_ELEMENT_NAME ).add_text( self.sender_name )  if self.sender_name
      xml_element.add_element( HEADLINE_ELEMENT_NAME ).add_text( self.headline )        if self.headline
      xml_element.add_element( DESCRIPTION_ELEMENT_NAME ).add_text( self.description )  if self.description
      xml_element.add_element( INSTRUCTION_ELEMENT_NAME ).add_text( self.instruction )  if self.instruction
      xml_element.add_element( WEB_ELEMENT_NAME ).add_text( self.web )                  if self.web
      xml_element.add_element( CONTACT_ELEMENT_NAME ).add_text( self.contact )          if self.contact
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

    def self.from_xml_element( info_xml_element )
      self.new(
        :language       => CAP.xpath_text( info_xml_element, LANGUAGE_XPATH ) || DEFAULT_LANGUAGE,
        :categories     => CAP.xpath_match( info_xml_element, CATEGORY_XPATH ).map{ |element| element.text },
        :event          => CAP.xpath_text( info_xml_element, EVENT_XPATH ),
        :response_types => CAP.xpath_match( info_xml_element, RESPONSE_TYPE_XPATH ).map{ |element| element.text },
        :urgency        => CAP.xpath_text( info_xml_element, URGENCY_XPATH ),
        :severity       => CAP.xpath_text( info_xml_element, SEVERITY_XPATH ),
        :certainty      => CAP.xpath_text( info_xml_element, CERTAINTY_XPATH ),
        :audience       => CAP.xpath_text( info_xml_element, AUDIENCE_XPATH ),
        :effective      => ( CAP.xpath_first( info_xml_element, EFFECTIVE_XPATH ) ? DateTime.strptime( CAP.xpath_text( info_xml_element, EFFECTIVE_XPATH )) : nil ),
        :onset          => ( CAP.xpath_first( info_xml_element, ONSET_XPATH) ? DateTime.strptime( CAP.xpath_text( info_xml_element, ONSET_XPATH )) : nil ),
        :expires        => ( CAP.xpath_first( info_xml_element, EXPIRES_XPATH ) ? DateTime.strptime( CAP.xpath_text( info_xml_element, EXPIRES_XPATH )) : nil ),
        :sender_name    => CAP.xpath_text( info_xml_element, SENDER_NAME_XPATH ),
        :headline       => CAP.xpath_text( info_xml_element, HEADLINE_XPATH ),
        :description    => CAP.xpath_text( info_xml_element, DESCRIPTION_XPATH ),
        :instruction    => CAP.xpath_text( info_xml_element, INSTRUCTION_XPATH ),
        :web            => CAP.xpath_text( info_xml_element, WEB_XPATH ),
        :contact        => CAP.xpath_text( info_xml_element, CONTACT_XPATH ),
				:event_codes    => CAP.xpath_match( info_xml_element, CAP::EventCode::XPATH ).map{ |element| CAP::EventCode.from_xml_element( element )},
				:parameters => CAP.xpath_match( info_xml_element, CAP::Parameter::XPATH ).map{ |element| CAP::Parameter.from_xml_element( element )},
				:areas => CAP.xpath_match( info_xml_element, CAP::Area::XPATH ).map{ |element| CAP::Area.from_xml_element( element )}
      )
    end
  end
end
