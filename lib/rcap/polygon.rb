module CAP
  class Polygon
    include Validation

    POINTS = :points
    GROUP_ATTRIBUTES = [ POINTS ]

    attr_reader( *GROUP_ATTRIBUTES )

    validates_validity_of_collection( POINTS )

    XML_ELEMENT_NAME = 'polygon'

    def to_s
      @points.map{ |point| point.to_s }.join( ' ' )
    end

    def to_xml_element
      xml_element = REXML::Element.new( XML_ELEMENT_NAME )
      xml_element.add_text( self.to_s )
      xml_element
    end
  end
end
