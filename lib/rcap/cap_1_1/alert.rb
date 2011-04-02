module RCAP
  module CAP_1_1
    # An Alert object is valid if
    # * it has an identifier
    # * it has a sender
    # * it has a sent time
    # * it has a valid status value
    # * it has a valid messge type value
    # * it has a valid scope value
    # * all Info objects contained in infos are valid
    class Alert
      include Validation

      XMLNS = "urn:oasis:names:tc:emergency:cap:1.1"
      CAP_VERSION = "1.1"

      STATUS_ACTUAL   = "Actual"   # :nodoc:
      STATUS_EXERCISE = "Exercise" # :nodoc:
      STATUS_SYSTEM   = "System"   # :nodoc:
      STATUS_TEST     = "Test"     # :nodoc:
      STATUS_DRAFT    = "Draft"    # :nodoc:
      # Valid values for status
      VALID_STATUSES = [ STATUS_ACTUAL, STATUS_EXERCISE, STATUS_SYSTEM, STATUS_TEST, STATUS_DRAFT ]

      MSG_TYPE_ALERT  = "Alert"   # :nodoc:
      MSG_TYPE_UPDATE = "Update"  # :nodoc:
      MSG_TYPE_CANCEL = "Cancel"  # :nodoc:
      MSG_TYPE_ACK    = "Ack"     # :nodoc:
      MSG_TYPE_ERROR  = "Error"   # :nodoc:
      # Valid values for msg_type
      VALID_MSG_TYPES = [ MSG_TYPE_ALERT, MSG_TYPE_UPDATE, MSG_TYPE_CANCEL, MSG_TYPE_ACK, MSG_TYPE_ERROR ]

      SCOPE_PUBLIC     = "Public"        # :nodoc:
      SCOPE_RESTRICTED = "Restricted"    # :nodoc:
      SCOPE_PRIVATE    = "Private"       # :nodoc:
      # Valid values for scope
      VALID_SCOPES = [ SCOPE_PUBLIC, SCOPE_PRIVATE, SCOPE_RESTRICTED ]

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

      # If not set a UUID will be set by default
      attr_accessor( :identifier)
      attr_accessor( :sender )
      # Sent Time - If not set will value will be time of creation.
      attr_accessor( :sent )
      # Value can only be one of VALID_STATUSES
      attr_accessor( :status )
      # Value can only be one of VALID_MSG_TYPES
      attr_accessor( :msg_type )
      # Value can only be one of VALID_SCOPES
      attr_accessor( :scope )
      attr_accessor( :source )
      # Depends on scope being SCOPE_RESTRICTED.
      attr_accessor( :restriction )
      attr_accessor( :note )

      # Collection of address strings. Depends on scope being SCOPE_PRIVATE.
      attr_reader( :addresses )
      attr_reader( :codes )
      # Collection of reference strings - see Alert#to_reference
      attr_reader( :references)
      # Collection of incident strings
      attr_reader( :incidents )
      # Collection of Info objects
      attr_reader( :infos )

      validates_presence_of( :identifier, :sender, :sent, :status, :msg_type, :scope )

      validates_inclusion_of( :status,   :in => VALID_STATUSES )
      validates_inclusion_of( :msg_type, :in => VALID_MSG_TYPES )
      validates_inclusion_of( :scope,    :in => VALID_SCOPES )

      validates_format_of( :identifier, :with => ALLOWED_CHARACTERS )
      validates_format_of( :sender ,    :with => ALLOWED_CHARACTERS )

      validates_dependency_of( :addresses,   :on => :scope, :with_value => SCOPE_PRIVATE )
      validates_dependency_of( :restriction, :on => :scope, :with_value => SCOPE_RESTRICTED )

      validates_collection_of( :infos )

      def initialize( attributes = {})
        @identifier  = attributes[ :identifier ]
        @sender      = attributes[ :sender ]
        @sent        = attributes[ :sent ]
        @status      = attributes[ :status ]
        @msg_type    = attributes[ :msg_type ]
        @scope       = attributes[ :scope ]
        @source      = attributes[ :source ]
        @restriction = attributes[ :restriction ]
        @addresses   = Array( attributes[ :addresses ])
        @codes       = Array( attributes[ :codes ])
        @references  = Array( attributes[ :references ])
        @incidents   = Array( attributes[ :incidents ])
        @infos       = Array( attributes[ :infos ])
      end

      # Creates a new Info object and adds it to the infos array. The
      # info_attributes are passed as a parameter to Info.new.
      def add_info( info_attributes  = {})
        info = Info.new( info_attributes )
        self.infos << info
        info
      end

      def to_xml_element #:nodoc:
        xml_element = REXML::Element.new( XML_ELEMENT_NAME )
        xml_element.add_namespace( XMLNS )
        xml_element.add_element( IDENTIFIER_ELEMENT_NAME ).add_text( self.identifier )   if self.identifier
        xml_element.add_element( SENDER_ELEMENT_NAME ).add_text( self.sender )           if self.sender
        xml_element.add_element( SENT_ELEMENT_NAME ).add_text( self.sent.to_s_for_cap )  if self.sent
        xml_element.add_element( STATUS_ELEMENT_NAME ).add_text( self.status )           if self.status
        xml_element.add_element( MSG_TYPE_ELEMENT_NAME ).add_text( self.msg_type )       if self.msg_type
        xml_element.add_element( SOURCE_ELEMENT_NAME ).add_text( self.source )           if self.source
        xml_element.add_element( SCOPE_ELEMENT_NAME ).add_text( self.scope )             if self.scope
        xml_element.add_element( RESTRICTION_ELEMENT_NAME ).add_text( self.restriction ) if self.restriction
        unless self.addresses.empty?
          xml_element.add_element( ADDRESSES_ELEMENT_NAME ).add_text( self.addresses.to_s_for_cap )
        end
        self.codes.each do |code|
          xml_element.add_element( CODE_ELEMENT_NAME ).add_text( code )
        end
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

      # Returns a string containing the XML representation of the alert.
      def to_xml
        self.to_xml_document.to_s
      end

      # Returns a string representation of the alert suitable for usage as a reference in a CAP message of the form
      #  sender,identifier,sent
      def to_reference
        "#{ self.sender },#{ self.identifier },#{ self.sent }"
      end

      def inspect # :nodoc:
        alert_inspect = <<EOF
CAP Version:  #{ CAP_VERSION }
Identifier:   #{ self.identifier }
Sender:       #{ self.sender }
Sent:         #{ self.sent }
Status:       #{ self.status }
Message Type: #{ self.msg_type }
Source:       #{ self.source }
Scope:        #{ self.scope }
Restriction:  #{ self.restriction }
Addresses:    #{ self.addresses.to_s_for_cap }
Codes:
#{ self.codes.map{ |code| "  #{ code }" }.join("\n")}
Note:         #{ self.note }
References:   #{ self.references.join( ' ' )}
Incidents:    #{ self.incidents.join( ' ')}
Information:
#{ self.infos.map{ |info| "  " + info.to_s }.join( "\n" )}
EOF
RCAP.format_lines_for_inspect( 'ALERT', alert_inspect )
      end

      # Returns a string representation of the alert of the form
      #  sender/identifier/sent
      # See Alert#to_reference for another string representation suitable as a CAP reference.
      def to_s
        "#{ self.sender }/#{ self.identifier }/#{ self.sent }"
      end

      def self.from_xml_element( alert_xml_element ) # :nodoc:
        self.new( :identifier  => RCAP.xpath_text( alert_xml_element, IDENTIFIER_XPATH, Alert::XMLNS ),
                 :sender      => RCAP.xpath_text( alert_xml_element, SENDER_XPATH, Alert::XMLNS ),
                 :sent        => (( sent = RCAP.xpath_first( alert_xml_element, SENT_XPATH, Alert::XMLNS )) ? DateTime.parse( sent.text ) : nil ),
                 :status      => RCAP.xpath_text( alert_xml_element, STATUS_XPATH, Alert::XMLNS ),
                 :msg_type    => RCAP.xpath_text( alert_xml_element, MSG_TYPE_XPATH, Alert::XMLNS ),
                 :source      => RCAP.xpath_text( alert_xml_element, SOURCE_XPATH, Alert::XMLNS ),
                 :scope       => RCAP.xpath_text( alert_xml_element, SCOPE_XPATH, Alert::XMLNS ),
                 :restriction => RCAP.xpath_text( alert_xml_element, RESTRICTION_XPATH, Alert::XMLNS ),
                 :addresses   => (( address = RCAP.xpath_text( alert_xml_element, ADDRESSES_XPATH, Alert::XMLNS )) ? address.unpack_cap_list : nil ),
                 :codes       => RCAP.xpath_match( alert_xml_element, CODE_XPATH, Alert::XMLNS ).map{ |element| element.text },
                 :note        => RCAP.xpath_text( alert_xml_element, NOTE_XPATH, Alert::XMLNS ),
                 :references  => (( references = RCAP.xpath_text( alert_xml_element, REFERENCES_XPATH, Alert::XMLNS )) ? references.split( ' ' ) : nil ),
                 :incidents   => (( incidents = RCAP.xpath_text( alert_xml_element, INCIDENTS_XPATH, Alert::XMLNS )) ? incidents.split( ' ' ) : nil ),
                 :infos       => RCAP.xpath_match( alert_xml_element, Info::XPATH, Alert::XMLNS ).map{ |element| Info.from_xml_element( element )})
      end

      def self.from_xml_document( xml_document ) # :nodoc:
        self.from_xml_element( xml_document.root )
      end

      # Initialise an Alert object from an XML string. Any object that is a subclass of IO (e.g. File) can be passed in.
      def self.from_xml( xml )
        self.from_xml_document( REXML::Document.new( xml ))
      end

      CAP_VERSION_YAML = "CAP Version"        # :nodoc:
      IDENTIFIER_YAML  = "Identifier"         # :nodoc:
      SENDER_YAML      = "Sender"             # :nodoc:
      SENT_YAML        = "Sent"               # :nodoc:
      STATUS_YAML      = "Status"             # :nodoc:
      MSG_TYPE_YAML    = "Message Type"       # :nodoc:
      SOURCE_YAML      = "Source"             # :nodoc:
      SCOPE_YAML       = "Scope"              # :nodoc:
      RESTRICTION_YAML = "Restriction"        # :nodoc:
      ADDRESSES_YAML   = "Addresses"          # :nodoc:
      CODES_YAML       = "Codes"              # :nodoc:
      NOTE_YAML        = "Note"               # :nodoc:
      REFERENCES_YAML  = "References"         # :nodoc:
      INCIDENTS_YAML   = "Incidents"          # :nodoc:
      INFOS_YAML       = "Information"        # :nodoc:

      # Returns a string containing the YAML representation of the alert.
      def to_yaml( options = {} )
        RCAP.attribute_values_to_hash(
          [ CAP_VERSION_YAML,  CAP_VERSION ],
          [ IDENTIFIER_YAML,    self.identifier ],
          [ SENDER_YAML,        self.sender ],
          [ SENT_YAML,          self.sent ],
          [ STATUS_YAML,        self.status ],
          [ MSG_TYPE_YAML,      self.msg_type ],
          [ SOURCE_YAML,        self.source ],
          [ SCOPE_YAML,         self.scope ],
          [ RESTRICTION_YAML,   self.restriction ],
          [ ADDRESSES_YAML,     self.addresses ],
          [ CODES_YAML,         self.codes ],
          [ NOTE_YAML,          self.note ],
          [ REFERENCES_YAML,    self.references ],
          [ INCIDENTS_YAML,     self.incidents ],
          [ INFOS_YAML,         self.infos ]
        ).to_yaml( options )
      end

      # Initialise an Alert object from a YAML string. Any object that is a subclass of IO (e.g. File) can be passed in.
      def self.from_yaml( yaml )
        self.from_yaml_data( YAML.load( yaml ))
      end

      def self.from_yaml_data( alert_yaml_data ) # :nodoc:
        Alert.new(
          :identifier  => alert_yaml_data[ IDENTIFIER_YAML ],
          :sender      => alert_yaml_data[ SENDER_YAML ],
          :sent        => ( sent = alert_yaml_data[ SENT_YAML ]).blank? ? nil : DateTime.parse( sent.to_s ),
          :status      => alert_yaml_data[ STATUS_YAML ],
          :msg_type    => alert_yaml_data[ MSG_TYPE_YAML ],
          :source      => alert_yaml_data[ SOURCE_YAML ],
          :scope       => alert_yaml_data[ SCOPE_YAML ],
          :restriction => alert_yaml_data[ RESTRICTION_YAML ],
          :addresses   => alert_yaml_data[ ADDRESSES_YAML ],
          :codes       => alert_yaml_data[ CODES_YAML ],
          :note        => alert_yaml_data[ NOTE_YAML ],
          :references  => alert_yaml_data[ REFERENCES_YAML ],
          :incidents   => alert_yaml_data[ INCIDENTS_YAML ],
          :infos       => Array( alert_yaml_data[ INFOS_YAML ]).map{ |info_yaml_data| Info.from_yaml_data( info_yaml_data )}
        )
      end

      CAP_VERSION_KEY = 'cap_version' # :nodoc:
      IDENTIFIER_KEY  = 'identifier'  # :nodoc:
      SENDER_KEY      = 'sender'      # :nodoc:
      SENT_KEY        = 'sent'        # :nodoc:
      STATUS_KEY      = 'status'      # :nodoc:
      MSG_TYPE_KEY    = 'msg_type'    # :nodoc:
      SOURCE_KEY      = 'source'      # :nodoc:
      SCOPE_KEY       = 'scope'       # :nodoc:
      RESTRICTION_KEY = 'restriction' # :nodoc:
      ADDRESSES_KEY   = 'addresses'   # :nodoc:
      CODES_KEY       = 'codes'       # :nodoc:
      NOTE_KEY        = 'note'        # :nodoc:
      REFERENCES_KEY  = 'references'  # :nodoc:
      INCIDENTS_KEY   = 'incidents'   # :nodoc:
      INFOS_KEY       = 'infos'       # :nodoc:

      # Returns a Hash representation of an Alert object
      def to_h
        RCAP.attribute_values_to_hash( [ CAP_VERSION_KEY, CAP_VERSION ],
                                      [ IDENTIFIER_KEY,   self.identifier ],
                                      [ SENDER_KEY,       self.sender ],
                                      [ SENT_KEY,         RCAP.to_s_for_cap( self.sent )],
                                      [ STATUS_KEY,       self.status ],
                                      [ MSG_TYPE_KEY,     self.msg_type ],
                                      [ SOURCE_KEY,       self.source ],
                                      [ SCOPE_KEY,        self.scope ],
                                      [ RESTRICTION_KEY,  self.restriction ],
                                      [ ADDRESSES_KEY,    self.addresses ],
                                      [ CODES_KEY,        self.codes ],
                                      [ NOTE_KEY,         self.note ],
                                      [ REFERENCES_KEY,   self.references ],
                                      [ INCIDENTS_KEY,    self.incidents ],
                                      [ INFOS_KEY,        self.infos.map{ |info| info.to_h  }])
      end

      # Initialises an Alert object from a Hash produced by Alert#to_h
      def self.from_h( alert_hash )
        self.new(
          :identifier  => alert_hash[ IDENTIFIER_KEY ],
          :sender      => alert_hash[ SENDER_KEY ],
          :sent        => RCAP.parse_datetime( alert_hash[ SENT_KEY ]),
          :status      => alert_hash[ STATUS_KEY ],
          :msg_type    => alert_hash[ MSG_TYPE_KEY ],
          :source      => alert_hash[ SOURCE_KEY ],
          :scope       => alert_hash[ SCOPE_KEY ],
          :restriction => alert_hash[ RESTRICTION_KEY ],
          :addresses   => alert_hash[ ADDRESSES_KEY ],
          :codes       => alert_hash[ CODES_KEY ],
          :note        => alert_hash[ NOTE_KEY ],
          :references  => alert_hash[ REFERENCES_KEY ],
          :incidents   => alert_hash[ INCIDENTS_KEY ],
          :infos       => Array( alert_hash[ INFOS_KEY ]).map{ |info_hash| Info.from_h( info_hash )})
      end

      # Returns a JSON string representation of an Alert object
      def to_json
        self.to_h.to_json
      end

      # Initiialises an Alert object from a JSON string produced by Alert#to_json
      def self.from_json( json_string )
        self.from_h( JSON.parse( json_string ))
      end
    end
  end
end
