module RCAP
  module Alert

    XMLNS_KEY            = "xmlns"
    YAML_CAP_VERSION_KEY = "CAP Version"
    JSON_CAP_VERSION_KEY = "cap_version"

    CAP_NAMESPACES = [ RCAP::CAP_1_0::Alert::XMLNS, RCAP::CAP_1_1::Alert::XMLNS, RCAP::CAP_1_2::Alert::XMLNS ]

    # Initialise a RCAP Alert from a XML document.
    #
    # @param [IO,String] xml CAP alert in XML format. Can be a String or any IO object.
    # @param [String] namespace_key The XML namespace that the CAP alert is in. If omitted
    #  the namespace of the document is inspected and a CAP_1_0::Alert, CAP_1_1::Alert
    #  or CAP_1_2::Alert is instantiated accordingly. If no namespace can be detected
    #  a CAP 1.2 message will be assumed.
    # @return [ RCAP::CAP_1_0::Alert, RCAP::CAP_1_1::Alert, RCAP::CAP_1_2::Alert ]
    def self.from_xml( xml, namespace_key = nil )
      xml_document = REXML::Document.new( xml )
      document_namespaces = xml_document.root.namespaces.invert
      namespace = namespace_key || CAP_NAMESPACES.find{ |namepsace| document_namespaces[ namepsace ]}

      case namespace
      when CAP_1_0::Alert::XMLNS
        CAP_1_0::Alert.from_xml_document( xml_document )
      when CAP_1_1::Alert::XMLNS
        CAP_1_1::Alert.from_xml_document( xml_document )
      else
        CAP_1_2::Alert.from_xml_document( xml_document )
      end
    end

    # Initialise a RCAP Alert from a YAML document produced by
    # CAP_1_2::Alert#to_yaml. The version of the document is inspected and a
    # CAP 1.0, 1.1 or 1.2 Alert is instantiated accordingly.
    #
    # @param [IO, String] yaml CAP Alert in YAML format. Can be a String or any IO object.
    # @return [ RCAP::CAP_1_0::Alert, RCAP::CAP_1_1::Alert, RCAP::CAP_1_2::Alert ]
    def self.from_yaml( yaml )
      yaml_data = YAML.load( yaml )

      case yaml_data[ YAML_CAP_VERSION_KEY ]
      when CAP_1_0::Alert::CAP_VERSION
        CAP_1_0::Alert.from_yaml_data( yaml_data )
      when CAP_1_1::Alert::CAP_VERSION
        CAP_1_1::Alert.from_yaml_data( yaml_data )
      else
        CAP_1_2::Alert.from_yaml_data( yaml_data )
      end
    end

    # Initialise a RCAP Alert from a JSON document produced by
    # CAP_1_2::Alert#to_json. The version of the document is inspected and a
    # CAP 1.0, 1.1 or 1.2 Alert is instantiated accordingly.
    #
    # @param [#to_s] json Alert in JSON format
    # @return [ RCAP::CAP_1_0::Alert, RCAP::CAP_1_1::Alert, RCAP::CAP_1_2::Alert ]
    def self.from_json( json )
      json_hash = JSON.parse( json.to_s )
      self.from_h( json_hash )
    end

    # Initialise a RCAP Alert from a Ruby hash produced by
    # CAP_1_2::Alert#to_h. The cap_version key  is inspected and a
    # CAP 1.0, 1.1 or 1.2 Alert is instantiated accordingly.
    #
    # @param [Hash] hash Alert as a Ruby hash.
    # @return [ RCAP::CAP_1_0::Alert, RCAP::CAP_1_1::Alert, RCAP::CAP_1_2::Alert ]
    def self.from_h( hash )
      case hash[ JSON_CAP_VERSION_KEY ]
      when CAP_1_0::Alert::CAP_VERSION
        CAP_1_0::Alert.from_h( hash )
      when CAP_1_1::Alert::CAP_VERSION
        CAP_1_1::Alert.from_h( hash )
      else
        CAP_1_2::Alert.from_h( hash )
      end
    end
  end
end
