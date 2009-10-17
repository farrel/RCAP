module CAP
  class Circle
    include Validation

    POINT  = :point
    RADIUS = :radius
    ATOMIC_ATTRIBUTES = [ POINT, RADIUS ]

    attr_accessor( *ATOMIC_ATTRIBUTES )

    validates_presence_of( *ATOMIC_ATTRIBUTES )
    validates_numericality_of( RADIUS, :greater_than => 0 )
    validates_validity_of( POINT )

    XML_ELEMENT_NAME = 'circle'

    def initialize( attributes = {} )
      @point = attributes[ POINT ]
      @radius = attributes[ RADIUS ]
    end

    def to_s
      "#{ self.point.to_s } #{ self.radius }"
    end

    def inspect
      "(#{ self.point.lattitude},#{ self.point.longitude } #{ self.radius })"
    end

    def to_xml_element
      xml_element = REXML::Element.new( XML_ELEMENT_NAME )
      xml_element.add_text( self.to_s )
      xml_element
    end

    def to_xml
      self.to_xml_element.to_s
    end
  end
end
