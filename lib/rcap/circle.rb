module CAP
  class Circle
    include Validation

    attr_accessor( :point, :radius )

    validates_presence_of( :point, :radius )
    validates_numericality_of( :radius , :greater_than => 0 )
    validates_validity_of( :point )

    XML_ELEMENT_NAME = 'circle' # :nodoc:

    XPATH = 'cap:circle' # :nodoc:

    def initialize( attributes = {} )
      @point = attributes[ :point ]
      @radius = attributes[ :radius ]
    end

    def to_s  # :nodoc:
      "#{ self.point.to_s } #{ self.radius }"
    end

    def inspect # :nodoc:
      "(#{ self.point.lattitude},#{ self.point.longitude } #{ self.radius })"
    end

    def to_xml_element # :nodoc:
      xml_element = REXML::Element.new( XML_ELEMENT_NAME )
      xml_element.add_text( self.to_s )
      xml_element
    end

    def to_xml
      self.to_xml_element.to_s
    end

    def self.parse_circle_string( circle_string ) # :nodoc:
      coordinates, radius = circle_string.split( ' ' )
      lattitude, longitude = coordinates.split( ',' )
      [ lattitude, longitude, radius ].map{ |e| e.to_f }
    end

    def self.from_xml_element( circle_xml_element ) # :nodoc:
      lattitude, longitude, radius = self.parse_circle_string( circle_xml_element.text )
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
