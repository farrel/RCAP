module CAP
	class Alert
		include Validation

		XMLNS = "urn:oasis:names:tc:emergency:cap:1.1"

		ADDRESSES   = :addresses
		REFERENCES  = :references
		INCIDENTS   = :incidents
		SOURCE      = :source
		RESTRICTION = :restriction
		CODE        = :code
		NOTE        = :note
		IDENTIFIER  = :identifier
		SENDER      = :sender
		SENT        = :sent
		STATUS      = :status
		MSG_TYPE    = :msg_type
		SCOPE       = :scope
    INFOS       = :infos

		REQUIRED_ATOMIC_ATTRIBUTES = [ IDENTIFIER, SENDER, SENT, STATUS, MSG_TYPE, SCOPE ]
		OPTIONAL_ATOMIC_ATTRIBUTES = [ SOURCE, RESTRICTION, CODE, NOTE ]
		OPTIONAL_GROUP_ATTRIBUTES  = [ ADDRESSES, REFERENCES, INCIDENTS, INFOS ]
		ALL_ATTRIBUTES             = REQUIRED_ATOMIC_ATTRIBUTES + OPTIONAL_ATOMIC_ATTRIBUTES + OPTIONAL_GROUP_ATTRIBUTES

		STATUS_ACTUAL   = "Actual"
		STATUS_EXERCISE = "Exercise"
		STATUS_SYSTEM   = "System"
		STATUS_TEST     = "Test"
		STATUS_DRAFT    = "Draft"
		ALL_STATUSES = [ STATUS_ACTUAL, STATUS_EXERCISE, STATUS_SYSTEM, STATUS_TEST, STATUS_DRAFT ]

		MSG_TYPE_ALERT  = "Alert"
		MSG_TYPE_UPDATE = "Update"
		MSG_TYPE_CANCEL = "Cancel"
		MSG_TYPE_ACK    = "Ack"
		MSG_TYPE_ERROR  = "Error"
		ALL_MSG_TYPES = [ MSG_TYPE_ALERT, MSG_TYPE_UPDATE, MSG_TYPE_CANCEL, MSG_TYPE_ACK, MSG_TYPE_ERROR ]  

		SCOPE_PUBLIC     = "Public"
		SCOPE_RESTRICTED = "Restricted"
		SCOPE_PRIVATE    = "Private"
		ALL_SCOPES = [ SCOPE_PUBLIC, SCOPE_PRIVATE, SCOPE_RESTRICTED ]

		attr_accessor( *( REQUIRED_ATOMIC_ATTRIBUTES + OPTIONAL_ATOMIC_ATTRIBUTES ))
		attr_reader( *OPTIONAL_GROUP_ATTRIBUTES )
		attr_reader( :infos )

		validates_presence_of( *REQUIRED_ATOMIC_ATTRIBUTES )
    validates_inclusion_of( STATUS, :in => ALL_STATUSES )
    validates_inclusion_of( MSG_TYPE, :in => ALL_MSG_TYPES )
    validates_inclusion_of( SCOPE, :in => ALL_SCOPES )
    validates_format_of( IDENTIFIER, :with => ALLOWED_CHARACTERS )
    validates_format_of( SENDER , :with => ALLOWED_CHARACTERS )
    validates_dependency_of( ADDRESSES, :on => SCOPE, :with_value => SCOPE_PRIVATE )
    validates_dependency_of( RESTRICTION, :on => SCOPE, :with_value => SCOPE_RESTRICTED )

		def initialize( attributes = {})
			@identifier = attributes[ IDENTIFIER ] || UUIDTools::UUID.random_create.to_s
			@sender = attributes[ SENDER ]
			@sent = attributes[ SENT ] || Time.now
			@status = attributes[ STATUS ]
			@scope = attributes[ SCOPE ]
			@source = attributes[ SOURCE ]
			@restriction = attributes[ SOURCE ]
			@addresses =  []
			@references = []
			@incidents = []
			@infos = []
		end

    XML_ELEMENT_NAME = 'alert'
    IDENTIFIER_ELEMENT_NAME = 'identifier'
    SENDER_ELEMENT_NAME = 'sender'
    SENT_ELEMENT_NAME = 'sent'
    STATUS_ELEMENT_NAME = 'status'
    MSG_TYPE_ELEMENT_NAME = 'msgType'
    SOURCE_ELEMENT_NAME = 'source'
    SCOPE_ELEMENT_NAME = 'scope'
    RESTRICTION_ELEMENT_NAME = 'restriction'
    ADDRESSES_ELEMENT_NAME = 'addresses'
    CODE_ELEMENT_NAME = 'code'
    NOTE_ELEMENT_NAME = 'note'
    REFERENCES_ELEMENT_NAME = 'references'
    INCIDENTS_ELEMENT_NAME = 'incidents'

    def to_xml_element
      xml_element = REXML::Element.new( XML_ELEMENT_NAME )
      xml_element.add_namespace( XMLNS )
      xml_element.add_element( IDENTIFIER_ELEMENT_NAME ).add_text( @identifier ) 
      xml_element.add_element( SENDER_ELEMENT_NAME ).add_text( @sender ) 
      xml_element.add_element( SENT_ELEMENT_NAME ).add_text( @sent.to_s ) 
      xml_element.add_element( STATUS_ELEMENT_NAME ).add_text( @status ) 
      xml_element.add_element( MSG_TYPE_ELEMENT_NAME ).add_text( @msg_type ) 
      xml_element.add_element( SOURCE_ELEMENT_NAME ).add_text( @source ) if @source
      xml_element.add_element( SCOPE_ELEMENT_NAME ).add_text( @scope ) 
      xml_element.add_element( RESTRICTION_ELEMENT_NAME ).add_text( @restriction ) if @restriction
      unless @addresses.empty?
        xml_element.add_element( ADDRESSES_ELEMENT_NAME ).add_text( @addresses )
      end
      xml_element.add_element( CODE_ELEMENT_NAME ).add_text( @code ) if @code
      xml_element.add_element( NOTE_ELEMENT_NAME ).add_text( @note ) if @note
      unless @references.empty?
        xml_element.add_element( REFERENCES_ELEMENT_NAME ).add_text( @references )
      end
      unless @incidents.empty?
        xml_element.add_element( INCIDENTS_ELEMENT_NAME ).add_text( @incidents )
      end
      @infos.each do |info|
        xml_element.add_element( info.to_xml_element )
      end
      xml_element
    end

    def to_xml_document
      xml_document = REXML::Document.new
      xml_document.add( self.to_xml_element )
      xml_document
    end

    def to_xml
      self.to_xml_document.to_s
    end
	end
end
