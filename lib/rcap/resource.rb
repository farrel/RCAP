module RCAP
	# A Resourse object is valid if
	# * it has a resource description
  class Resource
    include Validation

		# Resource Description
    attr_accessor( :resource_desc )
		attr_accessor( :mime_type )
		# Expressed in bytes
		attr_accessor( :size )
		# Resource location
		attr_accessor( :uri )
		# Dereferenced URI - contents of URI Base64 encoded
		attr_accessor( :deref_uri )
			# SHA-1 hash of contents of resource
		attr_accessor( :digest )

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

    def to_xml_element # :nodoc:
      xml_element = REXML::Element.new( XML_ELEMENT_NAME )
      xml_element.add_element( RESOURCE_DESC_ELEMENT_NAME ).add_text( self.resource_desc )
      xml_element.add_element( MIME_TYPE_ELEMENT_NAME ).add_text( self.mime_type ) if self.mime_type
      xml_element.add_element( SIZE_ELEMENT_NAME ).add_text( self.size ) if self.size
      xml_element.add_element( URI_ELEMENT_NAME ).add_text( self.uri ) if self.uri
      xml_element.add_element( DEREF_URI_ELEMENT_NAME ).add_text( self.deref_uri ) if self.deref_uri
      xml_element.add_element( DIGEST_ELEMENT_NAME ).add_text( self.digest ) if self.digest
      xml_element
    end

		# If size is defined returns the size in kilobytes
    def size_in_kb
      if self.size
        self.size.to_f/1024
      end
    end

    def to_xml # :nodoc:
      self.to_xml_element.to_s
    end

    def inspect # :nodoc:
      [ self.resource_desc, self.uri, self.mime_type, self.size ? format( "%.1fKB", self.size_in_kb ) : nil ].compact.join(' - ')
    end

		# Returns a string representation of the resource of the form
		#  resource_desc
    def to_s
      self.resource_desc
    end

    def self.from_xml_element( resource_xml_element ) # :nodoc:
      resource = self.new( :resource_desc => RCAP.xpath_text( resource_xml_element, RESOURCE_DESC_XPATH ),
                           :uri           => RCAP.xpath_text( resource_xml_element, URI_XPATH ),
                           :mime_type     => RCAP.xpath_text( resource_xml_element, MIME_TYPE_XPATH ),
                           :deref_uri     => RCAP.xpath_text( resource_xml_element, DEREF_URI_XPATH ),
                           :size          => RCAP.xpath_text( resource_xml_element, SIZE_XPATH ),
                           :digest        => RCAP.xpath_text( resource_xml_element, DIGEST_XPATH ))
    end
  end
end
