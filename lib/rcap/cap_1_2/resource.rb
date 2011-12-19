module RCAP
  module CAP_1_2

    # A Resource object is valid if
    # * it has a resource description
    # * it has a mime_type
    class Resource
      include Validation

      # Resource Description
      # @return [String]
      attr_accessor( :resource_desc )
      # MIME type as described in RFC 2046
      # @return [String]
      attr_accessor( :mime_type )
      # Expressed in bytes
      # @return [Integer]
      attr_accessor( :size )
      # Resource location
      # @return [String]
      attr_accessor( :uri )
      # Dereferenced URI - contents of URI Base64 encoded
      # @return [String]
      attr_accessor( :deref_uri )
      # SHA-1 hash of contents of resource
      # @return [String]
      attr_accessor( :digest )

      validates_presence_of( :resource_desc )
      validates_presence_of( :mime_type )

      XML_ELEMENT_NAME           = 'resource'     
      MIME_TYPE_ELEMENT_NAME     = 'mimeType'     
      SIZE_ELEMENT_NAME          = 'size'         
      URI_ELEMENT_NAME           = 'uri'          
      DEREF_URI_ELEMENT_NAME     = 'derefUri'     
      DIGEST_ELEMENT_NAME        = 'digest'       
      RESOURCE_DESC_ELEMENT_NAME = 'resourceDesc' 

      XPATH               = "cap:#{ XML_ELEMENT_NAME }"           
      MIME_TYPE_XPATH     = "cap:#{ MIME_TYPE_ELEMENT_NAME }"     
      SIZE_XPATH          = "cap:#{ SIZE_ELEMENT_NAME }"          
      URI_XPATH           = "cap:#{ URI_ELEMENT_NAME }"           
      DEREF_URI_XPATH     = "cap:#{ DEREF_URI_ELEMENT_NAME }"     
      DIGEST_XPATH        = "cap:#{ DIGEST_ELEMENT_NAME }"        
      RESOURCE_DESC_XPATH = "cap:#{ RESOURCE_DESC_ELEMENT_NAME }" 

      # @param [Hash{Symbol => Object}] attributes
      # @option attributes [String] :mime_type
      # @option attributes [Numeric] :size Size in bytes
      # @option attributes [String] :uri
      # @option attributes [String] :deref_uri
      # @option attributes [String] :digest
      # @option attributes [String] :resource_desc
      def initialize( attributes = {} )
        @mime_type     = attributes[ :mime_type ]
        @size          = attributes[ :size ]
        @uri           = attributes[ :uri ]
        @deref_uri     = attributes[ :deref_uri ]
        @digest        = attributes[ :digest ]
        @resource_desc = attributes[ :resource_desc ]
      end

      # @return [REXML::Element]
      def to_xml_element 
        xml_element = REXML::Element.new( XML_ELEMENT_NAME )
        xml_element.add_element( RESOURCE_DESC_ELEMENT_NAME ).add_text( @resource_desc )
        xml_element.add_element( MIME_TYPE_ELEMENT_NAME ).add_text( @mime_type ) if @mime_type
        xml_element.add_element( SIZE_ELEMENT_NAME ).add_text( @size.to_s )      if @size
        xml_element.add_element( URI_ELEMENT_NAME ).add_text( @uri )             if @uri
        xml_element.add_element( DEREF_URI_ELEMENT_NAME ).add_text( @deref_uri ) if @deref_uri
        xml_element.add_element( DIGEST_ELEMENT_NAME ).add_text( @digest )       if @digest
        xml_element
      end

      # If size is defined returns the size in kilobytes
      # @return [Float]
      def size_in_kb
        if @size
          @size.to_f/1024
        end
      end

      # @return [String]
      def to_xml 
        self.to_xml_element.to_s
      end

      # @return [String]
      def inspect 
        [ @resource_desc, @uri, @mime_type, @size ? format( "%.1fKB", @size_in_kb ) : nil ].compact.join(' - ')
      end

      # Returns a string representation of the resource of the form
      #  resource_desc
      #
      # @return [String]
      def to_s
        @resource_desc
      end

      # Retrieves the content at uri and stores it in deref_uri as Base64 encoded text. It will also
      # calculate the {#digest} on the encoded data using SHA1 and set the {#size}.
      #
      # This uses the open-uri[http://ruby-doc.org/stdlib/libdoc/open-uri/rdoc/index.html] Ruby API
      # to open and read the content. This method may throw an exception due to any number of network
      # related issue so please handle accordingly.
      #
      # Returns an array containing the size (in bytes) and SHA-1 hash.
      #
      # @return [Array(Integer,String)]
      def dereference_uri!
        content = URI.parse( self.uri ).read
        @deref_uri = Base64.encode64( content )
        self.calculate_hash_and_size
      end

      # Calculates the SHA-1 hash and size of the contents of {#deref_uri}.
      # Returns an array containing the size (in bytes) and SHA-1 hash if
      # {#deref_uri} is present otherwise returns nil.
      #
      # @return [nil,Array(Integer,String)]
      def calculate_hash_and_size
        if @deref_uri
          @digest = Digest::SHA1.hexdigest( @deref_uri )
          @size = @deref_uri.bytesize
          [ @size, @digest ]
        end
      end

      # The decoded contents of {#deref_uri} if present otherwise nil.
      #
      # @return [nil,String]
      def decoded_deref_uri
        Base64.decode64( @deref_uri ) if @deref_uri
      end

      # @param [REXML::Element] resource_xml_element
      # @return [Resource]
      def self.from_xml_element( resource_xml_element ) 
        resource = self.new( :resource_desc => RCAP.xpath_text( resource_xml_element, RESOURCE_DESC_XPATH, Alert::XMLNS ),
                             :uri           => RCAP.xpath_text( resource_xml_element, URI_XPATH, Alert::XMLNS ),
                             :mime_type     => RCAP.xpath_text( resource_xml_element, MIME_TYPE_XPATH, Alert::XMLNS ),
                             :deref_uri     => RCAP.xpath_text( resource_xml_element, DEREF_URI_XPATH, Alert::XMLNS ),
                             :size          => RCAP.xpath_text( resource_xml_element, SIZE_XPATH, Alert::XMLNS ).to_i,
                             :digest        => RCAP.xpath_text( resource_xml_element, DIGEST_XPATH, Alert::XMLNS ))
      end

      RESOURCE_DESC_YAML = "Resource Description" 
      URI_YAML           = "URI"                  
      MIME_TYPE_YAML     = "Mime Type"            
      DEREF_URI_YAML     = "Derefrenced URI Data" 
      SIZE_YAML          = "Size"                 
      DIGEST_YAML        = "Digest"               

      # @param [Hash] options
      # @return [String]
      def to_yaml( options = {} ) 
        RCAP.attribute_values_to_hash(
          [ RESOURCE_DESC_YAML, @resource_desc ],
          [ URI_YAML,           @uri ],
          [ MIME_TYPE_YAML,     @mime_type ],
          [ DEREF_URI_YAML,     @deref_uri ],
          [ SIZE_YAML,          @size ],
          [ DIGEST_YAML,        @digest ]).to_yaml( options )
      end

      # @param [Hash] resource_yaml_data
      # @return [Resource]
      def self.from_yaml_data( resource_yaml_data ) 
        self.new(
          :resource_desc => reource_yaml_data[ RESOURCE_DESC_YAML ],
          :uri           => reource_yaml_data[ URI_YAML ],
          :mime_type     => reource_yaml_data[ MIME_TYPE_YAML ],
          :deref_uri     => reource_yaml_data[ DEREF_URI_YAML ],
          :size          => reource_yaml_data[ SIZE_YAML ],
          :digest        => reource_yaml_data[ DIGEST_YAML ]
        )
      end

      RESOURCE_DESC_KEY = 'resource_desc' 
      URI_KEY           = 'uri'           
      MIME_TYPE_KEY     = 'mime_type'     
      DEREF_URI_KEY     = 'deref_uri'     
      SIZE_KEY          = 'size'          
      DIGEST_KEY        = 'digest'        

      # @return [Hash]
      def to_h 
        RCAP.attribute_values_to_hash(
          [ RESOURCE_DESC_KEY, @resource_desc ],
          [ URI_KEY,           @uri],
          [ MIME_TYPE_KEY,     @mime_type],
          [ DEREF_URI_KEY,     @deref_uri],
          [ SIZE_KEY,          @size ],
          [ DIGEST_KEY,        @digest ])
      end

      # @param [Hash] resource_hash
      # @return [Resource]
      def self.from_h( resource_hash ) 
        self.new(
          :resource_desc => resource_hash[ RESOURCE_DESC_KEY ],
          :uri           => resource_hash[ URI_KEY ],
          :mime_type     => resource_hash[ MIME_TYPE_KEY ],
          :deref_uri     => resource_hash[ DEREF_URI_KEY ],
          :size          => resource_hash[ SIZE_KEY ],
          :digest        => resource_hash[ DIGEST_KEY ])
      end
    end
  end
end
