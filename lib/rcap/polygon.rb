module CAP
  class Polygon
    include Validation

    POINTS = :points
    GROUP_ATTRIBUTES = [ POINTS ]

    attr_reader( *GROUP_ATTRIBUTES )

    validates_length_of( POINTS, :minimum => 1 )
    validates_collection_of( POINTS )

    XML_ELEMENT_NAME = 'polygon'

    def initialize
      @points = []
    end

    def to_s
      (@points.map{ |point| point.to_s }+@points.first).join( ' ' )
    end

    def to_xml_element
      xml_element = REXML::Element.new( XML_ELEMENT_NAME )
      xml_element.add_text( self.to_s )
      xml_element
    end
  end
end
