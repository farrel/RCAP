module CAP
  class Polygon
    include Validation

    POINTS = :points
    GROUP_ATTRIBUTES = [ POINTS ]

    attr_reader( *GROUP_ATTRIBUTES )

    validates_length_of( POINTS, :minimum => 3 )
    validates_collection_of( POINTS )

    XML_ELEMENT_NAME = 'polygon'
    XPATH = "/cap:alert/cap:info/cap:area/cap:#{ XML_ELEMENT_NAME }"

    def initialize( attributes = {})
      @points = Array( attributes[ :points ])
    end

    def to_s
      (@points.map{ |point| point.to_s } + [ @points.first ]).join( ' ' )
    end

    def inspect
      "(#{ @points.map{|point| point.inspect}.join(', ')})"
    end

    def to_xml_element
      xml_element = REXML::Element.new( XML_ELEMENT_NAME )
      xml_element.add_text( self.to_s )
      xml_element
    end

    def ==( other )
      self.points == other.points
    end

    def self.parse_polygon_string( polygon_string )
      polygon_string.split( ' ' ).map{ |coordinate_string| coordinate_string.split( ',' ).map{|coordinate| coordinate.to_f }}
    end

    def self.from_xml_element( polygon_xml_element )
      coordinates = self.parse_polygon_string( CAP.xpath_text( polygon_xml_element, XPATH ))
      points = coordinates.map{ |lattitude, longitude| CAP::Point.new( :lattitude => lattitude, :longitude => longitude )}[0..-2]
      polygon = self.new( :points => points )
    end
  end
end
