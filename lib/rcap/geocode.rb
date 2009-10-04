module CAP
  class Geocode
    include Validation

    NAME  = :name
    VALUE = :value
    ATOMIC_ATTRIBUTES = [ NAME, VALUE ]

    attr_accessor( *ATOMIC_ATTRIBUTES )

    validates_presence_of( *ATOMIC_ATTRIBUTES )

    XML_ELEMENT_NAME = 'geocode'
    
    def initialize( name, value )
      @name = name
      @value = value
    end

    def to_s
      "#{ @name }: #{ @value }"
    end

    def to_xml_element
      xml_element = REXML::Element.new( XML_ELEMENT_NAME )
      xml_element.add_element( 'valueName' ).add_text( @name.to_s )
      xml_element.add_element( 'value' ).add_text( @value.to_s )
      xml_element
    end

    def to_xml
      self.to_xml_element.to_s
    end
  end
end
