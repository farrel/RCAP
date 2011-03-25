module RCAP
  module Alert

    XMLNS_KEY            = "xmlns"
    YAML_CAP_VERSION_KEY = "CAP Version"
    JSON_CAP_VERSION_KEY = "cap_version"

    def self.from_xml( xml, namespace_key = XMLNS_KEY )
      xml_document = REXML::Document.new( xml )

      case xml_document.root.namespaces[ namespace_key ]
      when CAP_1_1::Alert::XMLNS
        CAP_1_1::Alert.from_xml_document( xml_document )
      else
        CAP_1_2::Alert.from_xml_document( xml_document )
      end

    end

    def self.from_yaml( yaml )
      yaml_data = YAML.load( yaml )

      case yaml_data[ YAML_CAP_VERSION_KEY ]
      when CAP_1_1::Alert::CAP_VERSION
        CAP_1_1::Alert.from_yaml_data( yaml_data )
      else
        CAP_1_2::Alert.from_yaml_data( yaml_data )
      end
    end

    def self.from_json( json_string )
      json_hash = JSON.parse( json_string )

      case json_hash[ JSON_CAP_VERSION_KEY ]
      when CAP_1_1::Alert::CAP_VERSION
        CAP_1_1::Alert.from_h( json_hash )
      else
        CAP_1_2::Alert.from_h( json_hash )
      end
    end
  end
end
