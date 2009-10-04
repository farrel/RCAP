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


		REQUIRED_ATOMIC_ATTRIBUTES = [ IDENTIFIER, SENDER, SENT, STATUS, MSG_TYPE, SCOPE ] 
		OPTIONAL_ATOMIC_ATTRIBUTES = [ SOURCE, RESTRICTION, CODE, NOTE ]

		OPTIONAL_GROUP_ATTRIBUTES = [ ADDRESSES, REFERENCES, INCIDENTS ]

		ALL_ATTRIBUTES = REQUIRED_ATOMIC_ATTRIBUTES + OPTIONAL_ATOMIC_ATTRIBUTES + OPTIONAL_GROUP_ATTRIBUTES

		attr_accessor( *( REQUIRED_ATOMIC_ATTRIBUTES + OPTIONAL_ATOMIC_ATTRIBUTES ))
		attr_reader( *OPTIONAL_GROUP_ATTRIBUTES )

		validates_presence_of( *REQUIRED_ATOMIC_ATTRIBUTES )


		STATUS_ACTUAL   = "Actual"
		STATUS_EXERCISE = "Exercise"
		STATUS_SYSTEM   = "System"
		STATUS_TEST     = "Test"
		STATUS_DRAFT    = "Draft"
		ALL_STATUSES = [ STATUS_ACTUAL, STATUS_EXERCISE, STATUS_SYSTEM, STATUS_TEST, STATUS_DRAFT ]
		validates_each( STATUS ) do |object, attribute, value|
			object.errors[ attribute ] << 'does not have a valid status value' unless ALL_STATUSES.include?( value )
		end

		MSG_TYPE_ALERT  = "Alert"
		MSG_TYPE_UPDATE = "Update"
		MSG_TYPE_CANCEL = "Cancel"
		MSG_TYPE_ACK    = "Ack"
		MSG_TYPE_ERROR  = "Error"
		ALL_MSG_TYPES = [ MSG_TYPE_ALERT, MSG_TYPE_UPDATE, MSG_TYPE_CANCEL, MSG_TYPE_ACK, MSG_TYPE_ERROR ]  
		validates_each( MSG_TYPE ) do |alert, attribute, msg_type|
			alert.errors[ attribute ] << 'does not have a valid message type' unless ALL_MSG_TYPES.include?( msg_type )
		end

		SCOPE_PUBLIC     = "Public"
		SCOPE_RESTRICTED = "Restricted"
		SCOPE_PRIVATE    = "Private"
		ALL_SCOPES = [ SCOPE_PUBLIC, SCOPE_PRIVATE, SCOPE_RESTRICTED ]
		validates_each( SCOPE ) do |alert, attribute, scope|
			alert.errors[ attribute ] << 'does not have a valid scope' unless ALL_SCOPES.include?( scope )
		end

		attr_reader( :infos )

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
	end
end
