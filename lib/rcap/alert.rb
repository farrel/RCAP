module CAP
	class Alert
		include Validation

		STATUS_ACTUAL   = "Actual"
		STATUS_EXERCISE = "Exercise"
		STATUS_SYSTEM   = "System"
		STATUS_TEST     = "Test"
		STATUS_DRAFT    = "Draft"
		ALL_STATUSES = [ STATUS_ACTUAL, STATUS_EXERCISE, STATUS_SYSTEM, STATUS_TEST, STATUS_DRAFT ] #:nodoc:

		MSG_TYPE_ALERT  = "Alert"
		MSG_TYPE_UPDATE = "Update"
		MSG_TYPE_CANCEL = "Cancel"
		MSG_TYPE_ACK    = "Ack"
		MSG_TYPE_ERROR  = "Error"
		ALL_MSG_TYPES = [ MSG_TYPE_ALERT, MSG_TYPE_UPDATE, MSG_TYPE_CANCEL, MSG_TYPE_ACK, MSG_TYPE_ERROR ] #:nodoc:  

		SCOPE_PUBLIC     = "Public"
		SCOPE_RESTRICTED = "Restricted"
		SCOPE_PRIVATE    = "Private"
		ALL_SCOPES = [ SCOPE_PUBLIC, SCOPE_PRIVATE, SCOPE_RESTRICTED ] #:nodoc:

    XML_ELEMENT_NAME         = 'alert'       # :nodoc:
    IDENTIFIER_ELEMENT_NAME  = 'identifier'  # :nodoc:
    SENDER_ELEMENT_NAME      = 'sender'      # :nodoc:
    SENT_ELEMENT_NAME        = 'sent'        # :nodoc:
    STATUS_ELEMENT_NAME      = 'status'      # :nodoc:
    MSG_TYPE_ELEMENT_NAME    = 'msgType'     # :nodoc:
    SOURCE_ELEMENT_NAME      = 'source'      # :nodoc:
    SCOPE_ELEMENT_NAME       = 'scope'       # :nodoc:
    RESTRICTION_ELEMENT_NAME = 'restriction' # :nodoc:
    ADDRESSES_ELEMENT_NAME   = 'addresses'   # :nodoc:
    CODE_ELEMENT_NAME        = 'code'        # :nodoc:
    NOTE_ELEMENT_NAME        = 'note'        # :nodoc:
    REFERENCES_ELEMENT_NAME  = 'references'  # :nodoc:
    INCIDENTS_ELEMENT_NAME   = 'incidents'   # :nodoc:

    XPATH             = 'cap:alert'                         # :nodoc: 
    IDENTIFIER_XPATH  = "cap:#{ IDENTIFIER_ELEMENT_NAME }"  # :nodoc: 
    SENDER_XPATH      = "cap:#{ SENDER_ELEMENT_NAME }"      # :nodoc: 
    SENT_XPATH        = "cap:#{ SENT_ELEMENT_NAME }"        # :nodoc: 
    STATUS_XPATH      = "cap:#{ STATUS_ELEMENT_NAME }"      # :nodoc: 
    MSG_TYPE_XPATH    = "cap:#{ MSG_TYPE_ELEMENT_NAME }"    # :nodoc: 
    SOURCE_XPATH      = "cap:#{ SOURCE_ELEMENT_NAME }"      # :nodoc: 
    SCOPE_XPATH       = "cap:#{ SCOPE_ELEMENT_NAME }"       # :nodoc: 
    RESTRICTION_XPATH = "cap:#{ RESTRICTION_ELEMENT_NAME }" # :nodoc: 
    ADDRESSES_XPATH   = "cap:#{ ADDRESSES_ELEMENT_NAME }"   # :nodoc: 
    CODE_XPATH        = "cap:#{ CODE_ELEMENT_NAME }"        # :nodoc: 
    NOTE_XPATH        = "cap:#{ NOTE_ELEMENT_NAME }"        # :nodoc: 
    REFERENCES_XPATH  = "cap:#{ REFERENCES_ELEMENT_NAME }"  # :nodoc: 
    INCIDENTS_XPATH   = "cap:#{ INCIDENTS_ELEMENT_NAME }"   # :nodoc: 

		attr_accessor( :identifier, :sender, :sent, :status, :msg_type, :scope, :source, :restriction, :code, :note )
		attr_reader(:addresses, :references, :incidents, :infos )

		validates_presence_of( :identifier, :sender, :sent, :status, :msg_type, :scope )

    validates_inclusion_of( :status, :in => ALL_STATUSES )
    validates_inclusion_of( :msg_type, :in => ALL_MSG_TYPES )
    validates_inclusion_of( :scope, :in => ALL_SCOPES )

    validates_format_of( :identifier, :with => ALLOWED_CHARACTERS )
    validates_format_of( :sender , :with => ALLOWED_CHARACTERS )

    validates_dependency_of( :addresses, :on => :scope, :with_value => SCOPE_PRIVATE )
    validates_dependency_of( :restriction, :on => :scope, :with_value => SCOPE_RESTRICTED )

    validates_collection_of( :infos )

		def initialize( attributes = {})
			@identifier  = attributes[ :identifier ] || UUIDTools::UUID.random_create.to_s
			@sender      = attributes[ :sender ]
			@sent        = attributes[ :sent ] || DateTime.now
			@status      = attributes[ :status ]
			@msg_type    = attributes[ :msg_type ]
			@scope       = attributes[ :scope ]
			@source      = attributes[ :source ]
			@restriction = attributes[ :restriction ]
			@addresses   = Array( attributes[ :addresses ])
			@references  = Array( attributes[ :references ])
			@incidents   = Array( attributes[ :incidents ])
			@infos       = Array( attributes[ :infos ])
		end

    def to_xml_element #:nodoc:
      xml_element = REXML::Element.new( XML_ELEMENT_NAME )
      xml_element.add_namespace( CAP::XMLNS )
      xml_element.add_element( IDENTIFIER_ELEMENT_NAME ).add_text( self.identifier ) 
      xml_element.add_element( SENDER_ELEMENT_NAME ).add_text( self.sender ) 
      xml_element.add_element( SENT_ELEMENT_NAME ).add_text( self.sent.to_s ) 
      xml_element.add_element( STATUS_ELEMENT_NAME ).add_text( self.status ) 
      xml_element.add_element( MSG_TYPE_ELEMENT_NAME ).add_text( self.msg_type ) 
      xml_element.add_element( SOURCE_ELEMENT_NAME ).add_text( self.source ) if self.source
      xml_element.add_element( SCOPE_ELEMENT_NAME ).add_text( self.scope ) 
      xml_element.add_element( RESTRICTION_ELEMENT_NAME ).add_text( self.restriction ) if self.restriction
      unless self.addresses.empty?
        xml_element.add_element( ADDRESSES_ELEMENT_NAME ).add_text( self.addresses.to_s_for_cap )
      end
      xml_element.add_element( CODE_ELEMENT_NAME ).add_text( self.code ) if self.code
      xml_element.add_element( NOTE_ELEMENT_NAME ).add_text( self.note ) if self.note
      unless self.references.empty?
        xml_element.add_element( REFERENCES_ELEMENT_NAME ).add_text( self.references.join( ' ' ))
      end
      unless self.incidents.empty?
        xml_element.add_element( INCIDENTS_ELEMENT_NAME ).add_text( self.incidents.join( ' ' ))
      end
      self.infos.each do |info|
        xml_element.add_element( info.to_xml_element )
      end
      xml_element
    end

    def to_xml_document #:nodoc:
      xml_document = REXML::Document.new
      xml_document.add( REXML::XMLDecl.new )
      xml_document.add( self.to_xml_element )
      xml_document
    end

    def to_xml
      self.to_xml_document.to_s
    end

    def to_reference
      "#{ self.sender },#{ self.identifier },#{ self.sent }"
    end

    def self.from_xml_element( alert_xml_element )
      alert = CAP::Alert.new( :identifier  => CAP.xpath_text( alert_xml_element, CAP::Alert::IDENTIFIER_XPATH ),
                              :sender      => CAP.xpath_text( alert_xml_element, SENDER_XPATH ),
                              :sent        => ( CAP.xpath_first( alert_xml_element, SENT_XPATH ) ? DateTime.strptime( CAP.xpath_text( alert_xml_element, SENT_XPATH )) : nil ),
                              :status      => CAP.xpath_text( alert_xml_element, STATUS_XPATH ),
                              :msg_type    => CAP.xpath_text( alert_xml_element, MSG_TYPE_XPATH ),
                              :source      => CAP.xpath_text( alert_xml_element, SOURCE_XPATH ),
                              :scope       => CAP.xpath_text( alert_xml_element, SCOPE_XPATH ),
                              :restriction => CAP.xpath_text( alert_xml_element, RESTRICTION_XPATH ),
                              :addresses   => CAP.xpath_text( alert_xml_element, ADDRESSES_XPATH ).unpack_cap_list,
                              :code        => CAP.xpath_text( alert_xml_element, CODE_XPATH ),
                              :note        => CAP.xpath_text( alert_xml_element, NOTE_XPATH ),
                              :references  => CAP.xpath_text( alert_xml_element, REFERENCES_XPATH ).split( ' ' ),
                              :incidents   => CAP.xpath_text( alert_xml_element, INCIDENTS_XPATH ).split( ' ' ),
                              :infos       => CAP.xpath_match( alert_xml_element, CAP::Info::XPATH ).each{ |element| CAP::Info.from_xml_element( element )})
    end
	end
end
