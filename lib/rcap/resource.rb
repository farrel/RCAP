module CAP
  class Resource
    include Validation

    attr_accessor( :resource_desc, :mime_type, :size, :uri, :deref_uri, :digest )

    validates_presence_of( :resource_desc )
    
    XML_ELEMENT_NAME           = 'resource'     # :nodoc: 
    MIME_TYPE_ELEMENT_NAME     = 'mimeType'     # :nodoc: 
    SIZE_ELEMENT_NAME          = 'size'         # :nodoc: 
    URI_ELEMENT_NAME           = 'uri'          # :nodoc: 
    DEREF_URI_ELEMENT_NAME     = 'derefUri'     # :nodoc: 
    DIGEST_ELEMENT_NAME        = 'digest'       # :nodoc: 
    RESOURCE_DESC_ELEMENT_NAME = 'resourceDesc' # :nodoc: 

    XPATH               = "cap:#{ XML_ELEMENT_NAME }"           # :nodoc: 
    MIME_TYPE_XPATH     = "cap:#{ MIME_TYPE_ELEMENT_NAME }"     # :nodoc: 
    SIZE_XPATH          = "cap:#{ SIZE_ELEMENT_NAME }"          # :nodoc: 
    URI_XPATH           = "cap:#{ URI_ELEMENT_NAME }"           # :nodoc: 
    DEREF_URI_XPATH     = "cap:#{ DEREF_URI_ELEMENT_NAME }"     # :nodoc: 
    DIGEST_XPATH        = "cap:#{ DIGEST_ELEMENT_NAME }"        # :nodoc: 
    RESOURCE_DESC_XPATH = "cap:#{ RESOURCE_DESC_ELEMENT_NAME }" # :nodoc: 

    def initialize( attributes = {} )
      @mime_type     = attributes[ :mime_type ]
      @size          = attributes[ :size ]
      @uri           = attributes[ :uri ]
      @deref_uri     = attributes[ :deref_uri ]
      @digest        = attributes[ :digest ]
      @resource_desc = attributes[ :resource_desc ]
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

    def self.from_xml_element( resource_xml_element )
      resource = self.new( :resource_desc => CAP.xpath_text( resource_xml_element, RESOURCE_DESC_XPATH ),
                           :uri           => CAP.xpath_text( resource_xml_element, URI_XPATH ),
                           :mime_type     => CAP.xpath_text( resource_xml_element, MIME_TYPE_XPATH ),
                           :deref_uri     => CAP.xpath_text( resource_xml_element, DEREF_URI_XPATH ),
                           :size          => CAP.xpath_text( resource_xml_element, SIZE_XPATH ),
                           :digest        => CAP.xpath_text( resource_xml_element, DIGEST_XPATH ))
    end
  end
end
