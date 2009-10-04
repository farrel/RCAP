module CAP
  class Resource
    include Validation

    MIME_TYPE     = :mime_type
    SIZE          = :size
    URI           = :uri
    DEREF_URI     = :deref_uri
    DIGEST        = :digest
    RESOURCE_DESC = :resource_desc

    OPTIONAL_ATOMIC_ATTRIBUTES = [ MIME_TYPE, SIZE, URI, DEREF_URI, DIGEST ]
    REQUIRED_ATOMIC_ATTRIBUTES = [ RESOURCE_DESC ]

    ALL_ATTRIBUTES = OPTIONAL_ATOMIC_ATTRIBUTES + REQUIRED_ATOMIC_ATTRIBUTES

    validates_presence_of( *REQUIRED_ATOMIC_ATTRIBUTES )

    attr_accessor( *( REQUIRED_ATOMIC_ATTRIBUTES + OPTIONAL_ATOMIC_ATTRIBUTES ))

    def initialize( attributes = {} )
      @mime_type = attributes[ MIME_TYPE ]
      @size = attributes[ SIZE ]
      @uri = attributes[ URI ]
      @deref_uri = attributes[ DEREF_URI ]
      @digest = attributes[ DIGEST ]
      @resource_desc = attributes[ RESOURCE_DESC ]
    end
  end
end
