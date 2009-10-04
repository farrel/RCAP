module CAP
  class Area
    include Validation

    ALTITUDE  = :altitude
    AREA_DESC = :area_desc
    CEILING   = :ceiling
    CIRCLES   = :circles
    GEOCODES  = :geocodes
    POLYGONS  = :polygons

    REQUIRED_ATOMIC_ATTRIBUTES = [ AREA_DESC ]
    OPTIONAL_ATOMIC_ATTRIBUTES = [ ALTITUDE, CEILING ]

    OPTIONAL_GROUP_ATTRIBUTES = [ CIRCLES, GEOCODES, POLYGONS ]

    attr_accessor( *( REQUIRED_ATOMIC_ATTRIBUTES + OPTIONAL_ATOMIC_ATTRIBUTES ))
    attr_reader( *( OPTIONAL_GROUP_ATTRIBUTES ))

    validates_presence_of( *REQUIRED_ATOMIC_ATTRIBUTES )

    validates_validity_of_collection( CIRCLES, POLYGONS, GEOCODES )

    XML_ELEMENT_NAME = 'area'

    def initialize( attributes = {})
      @altitude  = attributes[ ALTITUDE ]
      @area_desc = attributes[ AREA_DESC ]
      @ceiling   = attributes[ CEILING ]
      @circles   = []
      @geocodes  = []
      @polygons  = []
    end

    def to_xml_element
      xml_element = REXML::Element.new( XML_ELEMENT_NAME )
      xml_element.add_element( 'areaDesc' ).add_text( @area_desc.to_s )
      xml_element.add_element( 'altitude' ).add_text( @altitude.to_s ) if @altitude
      xml_element.add_element( 'ceiling' ).add_text( @ceiling.to_s ) if @ceiling
      add_to_xml_element = lambda do |element, object|
        element.add_element( object.to_xml_element )
        element
      end
      @circles.inject( xml_element, &add_to_xml_element )
      @polygons.inject( xml_element, &add_to_xml_element )
      @geocodes.inject( xml_element, &add_to_xml_element )
      xml_element
    end

    def to_xml
      self.to_xml_element.to_s
    end
  end
end
