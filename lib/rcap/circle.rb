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

    XPATH = '/cap:alert/cap:info/cap:area/cap:circle'

    def initialize( attributes = {} )
      @point = attributes[ POINT ]
      @radius = attributes[ RADIUS ].to_f
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

    def self.parse_circle_string( circle_string )
      coordinates, radius = circle_string.split( ' ' )
      lattitude, longitude = coordinates.split( ',' )
      [ lattitude, longitude, radius ].map{ |e| e.to_f }
    end

    def self.from_xml_element( circle_xml_element )
      lattitude, longitude, radius = self.parse_circle_string( CAP.xpath_text( circle_xml_element, XPATH ))
      point = CAP::Point.new( :lattitude => lattitude, :longitude => longitude )
      circle = self.new( :point  => point,
                         :radius => radius )
    end

    def ==( other )
      self.point == other.point &&
        self.radius == other.radius
    end
  end
end
