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
    OPTIONAL_GROUP_ATTRIBUTES  = [ CIRCLES, GEOCODES, POLYGONS ]

    attr_accessor( *( REQUIRED_ATOMIC_ATTRIBUTES + OPTIONAL_ATOMIC_ATTRIBUTES ))
    attr_reader( *( OPTIONAL_GROUP_ATTRIBUTES ))

    validates_presence_of( *REQUIRED_ATOMIC_ATTRIBUTES )
    validates_collection_of( CIRCLES, POLYGONS, GEOCODES )
    validates_dependency_of( CEILING, :on => ALTITUDE )

    XML_ELEMENT_NAME       = 'area'
    AREA_DESC_ELEMENT_NAME = 'areaDesc'
    ALTITUDE_ELEMENT_NAME  = 'altitude'
    CEILING_ELEMENT_NAME   = 'ceiling'

    XPATH = "/cap:alert/cap:info/cap:#{ XML_ELEMENT_NAME }"
    ALTITUDE_XPATH = XPATH + "/cap:#{ ALTITUDE_ELEMENT_NAME }" 
    AREA_DESC_XPATH = XPATH + "/cap:#{ AREA_DESC_ELEMENT_NAME }"
    CEILING_XPATH = XPATH + "/cap:#{ CEILING_ELEMENT_NAME }"  

    def initialize( attributes = {})
      @area_desc = attributes[ AREA_DESC ]
      @altitude  = attributes[ ALTITUDE ]
      @ceiling   = attributes[ CEILING ]
      @circles   = Array( attributes[ CIRCLES ])
      @geocodes  = Array( attributes[ GEOCODES ])
      @polygons  = Array( attributes[ POLYGONS ])
    end

    def to_xml_element
      xml_element = REXML::Element.new( XML_ELEMENT_NAME )
      xml_element.add_element( AREA_DESC_ELEMENT_NAME ).add_text( @area_desc.to_s )
      add_to_xml_element = lambda do |element, object|
        element.add_element( object.to_xml_element )
        element
      end
      @polygons.inject( xml_element, &add_to_xml_element )
      @circles.inject( xml_element, &add_to_xml_element )
      @geocodes.inject( xml_element, &add_to_xml_element )
      xml_element.add_element( ALTITUDE_ELEMENT_NAME ).add_text( @altitude.to_s ) unless self.altitude.blank?
      xml_element.add_element( CEILING_ELEMENT_NAME ).add_text( @ceiling.to_s ) unless self.altitude.blank?
      xml_element
    end

    def to_xml
      self.to_xml_element.to_s
    end

    def self.from_xml_element( area_xml_element )
      area = CAP::Area.new( :area_desc => CAP.xpath_text( area_xml_element, AREA_DESC_XPATH ),
                            :altitude  => CAP.xpath_text( area_xml_element, ALTITUDE_XPATH ).to_f,
                            :ceiling   => CAP.xpath_text( area_xml_element, CEILING_XPATH ).to_f,
                            :circles   => CAP.xpath_match( area_xml_element, CAP::Circle::XPATH ).map{ |circle_element| CAP::Circle.from_xml_element( circle_element )},
                            :geocodes  => CAP.xpath_match( area_xml_element, CAP::Geocode::XPATH ).map{ |geocode_element| CAP::Geocode.from_xml_element( geocode_element )},
                            :polygons  => CAP.xpath_match( area_xml_element, CAP::Polygon::XPATH ).map{ |polygon_element| CAP::Polygon.from_xml_element( polygon_element )})
    end
  end
end
