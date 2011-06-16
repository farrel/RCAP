module RCAP
  module CAP_1_0
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
        xml_element.add_element( SIZE_ELEMENT_NAME ).add_text( self.size )           if self.size
        xml_element.add_element( URI_ELEMENT_NAME ).add_text( self.uri )             if self.uri
        xml_element.add_element( DEREF_URI_ELEMENT_NAME ).add_text( self.deref_uri ) if self.deref_uri
        xml_element.add_element( DIGEST_ELEMENT_NAME ).add_text( self.digest )       if self.digest
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
        resource = self.new( :resource_desc => RCAP.xpath_text( resource_xml_element, RESOURCE_DESC_XPATH, Alert::XMLNS ),
                            :uri           => RCAP.xpath_text( resource_xml_element, URI_XPATH, Alert::XMLNS ),
                            :mime_type     => RCAP.xpath_text( resource_xml_element, MIME_TYPE_XPATH, Alert::XMLNS ),
                            :deref_uri     => RCAP.xpath_text( resource_xml_element, DEREF_URI_XPATH, Alert::XMLNS ),
                            :size          => RCAP.xpath_text( resource_xml_element, SIZE_XPATH, Alert::XMLNS ),
                            :digest        => RCAP.xpath_text( resource_xml_element, DIGEST_XPATH, Alert::XMLNS ))
      end

      RESOURCE_DESC_YAML = "Resource Description" # :nodoc:
      URI_YAML           = "URI"                  # :nodoc:
      MIME_TYPE_YAML     = "Mime Type"            # :nodoc:
      DEREF_URI_YAML     = "Derefrenced URI Data" # :nodoc:
      SIZE_YAML          = "Size"                 # :nodoc:
      DIGEST_YAML        = "Digest"               # :nodoc:

      def to_yaml( options ) # :nodoc:
        RCAP.attribute_values_to_hash(
          [ RESOURCE_DESC_YAML, self.resource_desc ],
          [ URI_YAML,           self.uri ],
          [ MIME_TYPE_YAML,     self.mime_type ],
          [ DEREF_URI_YAML,     self.deref_uri ],
          [ SIZE_YAML,          self.size ],
          [ DIGEST_YAML,        self.digest ]
        ).to_yaml( options )
      end

      def self.from_yaml_data( resource_yaml_data ) # :nodoc:
        self.new(
          :resource_desc => reource_yaml_data[ RESOURCE_DESC_YAML ],
          :uri           => reource_yaml_data[ URI_YAML ],
          :mime_type     => reource_yaml_data[ MIME_TYPE_YAML ],
          :deref_uri     => reource_yaml_data[ DEREF_URI_YAML ],
          :size          => reource_yaml_data[ SIZE_YAML ],
          :digest        => reource_yaml_data[ DIGEST_YAML ]
        )
      end

      RESOURCE_DESC_KEY = 'resource_desc' # :nodoc:
      URI_KEY           = 'uri'           # :nodoc:
      MIME_TYPE_KEY     = 'mime_type'     # :nodoc:
      DEREF_URI_KEY     = 'deref_uri'     # :nodoc:
      SIZE_KEY          = 'size'          # :nodoc:
      DIGEST_KEY        = 'digest'        # :nodoc:

      def to_h # :nodoc:
        RCAP.attribute_values_to_hash(
          [ RESOURCE_DESC_KEY, self.resource_desc ],
          [ URI_KEY,           self.uri],
          [ MIME_TYPE_KEY,     self.mime_type],
          [ DEREF_URI_KEY,     self.deref_uri],
          [ SIZE_KEY,          self.size ],
          [ DIGEST_KEY,        self.digest ])
      end

      def self.from_h( resource_hash ) # :nodoc:
        self.new(
          :resource_desc => resource_hash[ RESOURCE_DESC_KEY ],
          :uri => resource_hash[ URI_KEY ],
          :mime_type => resource_hash[ MIME_TYPE_KEY ],
          :deref_uri => resource_hash[ DEREF_URI_KEY ],
          :size => resource_hash[ SIZE_KEY ],
          :digest => resource_hash[ DIGEST_KEY ])
      end
    end
  end
end
