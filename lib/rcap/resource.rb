module CAP
  class Resource
    include Validation

    MIME_TYPE     = :mime_type
    SIZE          = :size
    URI           = :uri
    DEREF_URI     = :deref_uri
    DIGEST        = :digest
    RESOURCE_DESC = :resource_desc

    OPTIONAL_ATOMIC_ELEMENTS = [ MIME_TYPE, SIZE, URI, DEREF_URI, DIGEST ]
    REQUIRED_ATOMIC_ELEMENTS = [ RESOURCE_DESC ]

    ALL_ELEMENTS = OPTIONAL_ATOMIC_ELEMENTS + REQUIRED_ATOMIC_ELEMENTS

    validates_presence_of( *REQUIRED_ATOMIC_ELEMENTS )

    attr_accessor( *( REQUIRED_ATOMIC_ELEMENTS + OPTIONAL_ATOMIC_ELEMENTS ))

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
