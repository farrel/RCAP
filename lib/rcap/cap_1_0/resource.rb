module RCAP
  module CAP_1_0

    # A Resource object is valid if
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
      # SHA-1 hash of contents of resource
      attr_accessor( :digest )

      validates_presence_of( :resource_desc )

      XML_ELEMENT_NAME           = 'resource'     
      MIME_TYPE_ELEMENT_NAME     = 'mimeType'     
      SIZE_ELEMENT_NAME          = 'size'         
      URI_ELEMENT_NAME           = 'uri'          
      DIGEST_ELEMENT_NAME        = 'digest'       
      RESOURCE_DESC_ELEMENT_NAME = 'resourceDesc' 

      XPATH               = "cap:#{ XML_ELEMENT_NAME }"           
      MIME_TYPE_XPATH     = "cap:#{ MIME_TYPE_ELEMENT_NAME }"     
      SIZE_XPATH          = "cap:#{ SIZE_ELEMENT_NAME }"          
      URI_XPATH           = "cap:#{ URI_ELEMENT_NAME }"           
      DIGEST_XPATH        = "cap:#{ DIGEST_ELEMENT_NAME }"        
      RESOURCE_DESC_XPATH = "cap:#{ RESOURCE_DESC_ELEMENT_NAME }" 

      def initialize( attributes = {} )
        @mime_type     = attributes[ :mime_type ]
        @size          = attributes[ :size ]
        @uri           = attributes[ :uri ]
        @digest        = attributes[ :digest ]
        @resource_desc = attributes[ :resource_desc ]
      end

      def to_xml_element 
        xml_element = REXML::Element.new( XML_ELEMENT_NAME )
        xml_element.add_element( RESOURCE_DESC_ELEMENT_NAME ).add_text( @resource_desc )
        xml_element.add_element( MIME_TYPE_ELEMENT_NAME ).add_text( @mime_type ) if @mime_type
        xml_element.add_element( SIZE_ELEMENT_NAME ).add_text( @size.to_s )      if @size
        xml_element.add_element( URI_ELEMENT_NAME ).add_text( @uri )             if @uri
        xml_element.add_element( DIGEST_ELEMENT_NAME ).add_text( @digest )       if @digest
        xml_element
      end

      # If size is defined returns the size in kilobytes
      def size_in_kb
        if @size
          @size.to_f/1024
        end
      end

      def to_xml 
        self.to_xml_element.to_s
      end

      def inspect 
        [ @resource_desc, @uri, @mime_type, @size ? format( "%.1fKB", @size_in_kb ) : nil ].compact.join(' - ')
      end

      # Returns a string representation of the resource of the form
      #  resource_desc
      def to_s
        @resource_desc
      end

      def self.from_xml_element( resource_xml_element ) 
        resource = self.new( :resource_desc => RCAP.xpath_text( resource_xml_element, RESOURCE_DESC_XPATH, Alert::XMLNS ),
                             :uri           => RCAP.xpath_text( resource_xml_element, URI_XPATH, Alert::XMLNS ),
                             :mime_type     => RCAP.xpath_text( resource_xml_element, MIME_TYPE_XPATH, Alert::XMLNS ),
                             :size          => RCAP.xpath_text( resource_xml_element, SIZE_XPATH, Alert::XMLNS ).to_i,
                             :digest        => RCAP.xpath_text( resource_xml_element, DIGEST_XPATH, Alert::XMLNS ))
      end

      RESOURCE_DESC_YAML = "Resource Description" 
      URI_YAML           = "URI"                  
      MIME_TYPE_YAML     = "Mime Type"            
      SIZE_YAML          = "Size"                 
      DIGEST_YAML        = "Digest"               

      def to_yaml( options = {} ) 
        RCAP.attribute_values_to_hash(
          [ RESOURCE_DESC_YAML, @resource_desc ],
          [ URI_YAML,           @uri ],
          [ MIME_TYPE_YAML,     @mime_type ],
          [ SIZE_YAML,          @size ],
          [ DIGEST_YAML,        @digest ]
        ).to_yaml( options )
      end

      def self.from_yaml_data( resource_yaml_data ) 
        self.new(
          :resource_desc => reource_yaml_data[ RESOURCE_DESC_YAML ],
          :uri           => reource_yaml_data[ URI_YAML ],
          :mime_type     => reource_yaml_data[ MIME_TYPE_YAML ],
          :size          => reource_yaml_data[ SIZE_YAML ],
          :digest        => reource_yaml_data[ DIGEST_YAML ]
        )
      end

      RESOURCE_DESC_KEY = 'resource_desc' 
      URI_KEY           = 'uri'           
      MIME_TYPE_KEY     = 'mime_type'     
      SIZE_KEY          = 'size'          
      DIGEST_KEY        = 'digest'        

      def to_h 
        RCAP.attribute_values_to_hash(
          [ RESOURCE_DESC_KEY, @resource_desc ],
          [ URI_KEY,           @uri],
          [ MIME_TYPE_KEY,     @mime_type],
          [ SIZE_KEY,          @size ],
          [ DIGEST_KEY,        @digest ])
      end

      def self.from_h( resource_hash ) 
        self.new(
          :resource_desc => resource_hash[ RESOURCE_DESC_KEY ],
          :uri           => resource_hash[ URI_KEY ],
          :mime_type     => resource_hash[ MIME_TYPE_KEY ],
          :size          => resource_hash[ SIZE_KEY ],
          :digest        => resource_hash[ DIGEST_KEY ])
      end
    end
  end
end
