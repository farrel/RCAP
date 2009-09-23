module CAP
  class Alert
    include Validation

    XMLNS = "urn:oasis:names:tc:emergency:cap:1.1"

    REQUIRED_ELEMENTS = [ :identifier, :sender, :sent, :status, :msg_type, :scope ] 
    OPTIONAL_ELEMENTS = [ :source, :restriction, :addresses, :code, :note, :references, :incidents ]
    ALL_ELEMENTS = REQUIRED_ELEMENTS + OPTIONAL_ELEMENTS

    attr_accessor( *ALL_ELEMENTS )
    validates_presence_of( *REQUIRED_ELEMENTS )


    STATUS_ACTUAL   = "Actual"
    STATUS_EXERCISE = "Exercise"
    STATUS_SYSTEM   = "System"
    STATUS_TEST     = "Test"
    STATUS_DRAFT    = "Draft"
    ALL_STATUSES = [ STATUS_ACTUAL, STATUS_EXERCISE, STATUS_SYSTEM, STATUS_TEST, STATUS_DRAFT ]
    validates_each( :status ) do |object, attribute, value|
      object.errors[ attribute ] << 'does not have a valid status value' unless ALL_STATUSES.include?( value )
    end

    MSG_TYPE_ALERT  = "Alert"
    MSG_TYPE_UPDATE = "Update"
    MSG_TYPE_CANCEL = "Cancel"
    MSG_TYPE_ACK    = "Ack"
    MSG_TYPE_ERROR  = "Error"
    ALL_MSG_TYPES = [ MSG_TYPE_ALERT, MSG_TYPE_UPDATE, MSG_TYPE_CANCEL, MSG_TYPE_ACK, MSG_TYPE_ERROR ]  
    validates_each( :msg_type ) do |alert, attribute, msg_type|
      alert.errors[ attribute ] << 'does not have a valid message type' unless ALL_MSG_TYPES.include?( msg_type )
    end

    SCOPE_PUBLIC     = "Public"
    SCOPE_RESTRICTED = "Restricted"
    SCOPE_PRIVATE    = "Private"
    ALL_SCOPES = [ SCOPE_PUBLIC, SCOPE_PRIVATE, SCOPE_RESTRICTED ]
    validates_each( :scope ) do |alert, attribute, scope|
      alert.errors[ attribute ] << 'does not have a valid scope' unless ALL_SCOPES.include?( scope )
    end

    attr_accessor( :infos )

    def initialize( attributes = {})
      @identifier = attributes[ :identifier ] || UUIDTools::UUID.random_create.to_s
      @sender = attributes[ :sender ]
      @sent = attributes[ :sent ] || Time.now
      @status = attributes[ :status ]
      @scope = attributes[ :scope ]
      @source = attributes[ :source ]
      @restriction = attributes[ :source ]
      @addresses = attributes[ :addresses ] || []
      @references = attributes[ :references ] || []
      @incidents = attributes[ :incidents ] || []
    end
  end
end
