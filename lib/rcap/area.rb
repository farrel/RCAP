module CAP
  class Area
    include Validation

    attr_accessor( :area_desc, :altitude, :ceiling )
    attr_reader( :circles, :geocodes, :polygons )

    validates_presence_of( :area_desc )
    validates_collection_of( :circles, :geocodes, :polygons )
    validates_dependency_of( :ceiling, :on => :altitude )

    XML_ELEMENT_NAME       = 'area'     # :nodoc: 
    AREA_DESC_ELEMENT_NAME = 'areaDesc' # :nodoc: 
    ALTITUDE_ELEMENT_NAME  = 'altitude' # :nodoc: 
    CEILING_ELEMENT_NAME   = 'ceiling'  # :nodoc: 

    XPATH           = "cap:#{ XML_ELEMENT_NAME }"       # :nodoc: 
    AREA_DESC_XPATH = "cap:#{ AREA_DESC_ELEMENT_NAME }" # :nodoc: 
    ALTITUDE_XPATH  = "cap:#{ ALTITUDE_ELEMENT_NAME }"  # :nodoc: 
    CEILING_XPATH   = "cap:#{ CEILING_ELEMENT_NAME }"   # :nodoc: 

    def initialize( attributes = {})
      @area_desc = attributes[ :area_desc ]
      @altitude  = attributes[ :altitude ]
      @ceiling   = attributes[ :ceiling ]
      @circles   = Array( attributes[ :circles ])
      @geocodes  = Array( attributes[ :geocodes ])
      @polygons  = Array( attributes[ :polygons ])
    end

    def to_xml_element # :nodoc:
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

		def ==( other )
			comparison_attributes = lambda{ |area| [ area.area_desc, area.altitude, area.ceiling, area.circles, area.geocodes, area.polygons ]}
			comparison_attributes.call( self ) == comparison_attributes.call( other )
		end

    def self.from_xml_element( area_xml_element ) # :nodoc:
      area = CAP::Area.new( :area_desc => CAP.xpath_text( area_xml_element, AREA_DESC_XPATH ),
                            :altitude  => (( alt = CAP.xpath_text( area_xml_element, ALTITUDE_XPATH )) ? alt.to_f : nil ),
                            :ceiling   => (( ceil = CAP.xpath_text( area_xml_element, CEILING_XPATH )) ? ceil.to_f : nil ),
                            :circles   => CAP.xpath_match( area_xml_element, CAP::Circle::XPATH ).map{ |circle_element| CAP::Circle.from_xml_element( circle_element )},
                            :geocodes  => CAP.xpath_match( area_xml_element, CAP::Geocode::XPATH ).map{ |geocode_element| CAP::Geocode.from_xml_element( geocode_element )},
                            :polygons  => CAP.xpath_match( area_xml_element, CAP::Polygon::XPATH ).map{ |polygon_element| CAP::Polygon.from_xml_element( polygon_element )})
			area
    end
  end
end
