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

    validates_presence_of( *REQUIRED_ATOMIC_ATTRIBUTES )

    attr_accessor( *( REQUIRED_ATOMIC_ATTRIBUTES + OPTIONAL_ATOMIC_ATTRIBUTES ))
    
    XML_ELEMENT_NAME           = 'resource'
    MIME_TYPE_ELEMENT_NAME     = 'mimeType'
    SIZE_ELEMENT_NAME          = 'size'
    URI_ELEMENT_NAME           = 'uri'
    DEREF_URI_ELEMENT_NAME     = 'derefUri'
    DIGEST_ELEMENT_NAME        = 'digest'
    RESOURCE_DESC_ELEMENT_NAME = 'resourceDesc'

    def initialize( attributes = {} )
      @mime_type     = attributes[ MIME_TYPE ]
      @size          = attributes[ SIZE ]
      @uri           = attributes[ URI ]
      @deref_uri     = attributes[ DEREF_URI ]
      @digest        = attributes[ DIGEST ]
      @resource_desc = attributes[ RESOURCE_DESC ]
    end

    def to_xml_element
      xml_element = REXML::Element.new( XML_ELEMENT_NAME )
      xml_element.add_element( RESOURCE_DESC_ELEMENT_NAME ).add_text( self.resource_desc )
      xml_element.add_element( MIME_TYPE_ELEMENT_NAME ).add_text( self.mime_type ) if self.mime_type
      xml_element.add_element( SIZE_ELEMENT_NAME ).add_text( self.size ) if self.size
      xml_element.add_element( URI_ELEMENT_NAME ).add_text( self.uri ) if self.uri
      xml_element.add_element( DEREF_URI_ELEMENT_NAME ).add_text( self.deref_uri ) if self.deref_uri
      xml_element.add_element( DIGEST_ELEMENT_NAME ).add_text( self.digest ) if self.digest
      xml_element
    end

    def size_in_kb
      if self.size
        self.size.to_f/1024
      end
    end

    def to_xml
      self.to_xml_element.to_s
    end

    def inspect
      [ self.resource_desc, self.uri, self.mime_type, self.size ? format( "%.1fKB", self.size_in_kb ) : nil ].compact.join(' - ')
    end
  end
end
