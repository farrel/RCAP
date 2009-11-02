module RCAP
	# An Area object is valid if
	# * it has an area description
	# * all Circle objects contained in circles are valid
	# * all Geocode objects contained in geocodes are valid
	# * all Polygon objects contained in polygons are valid
	# * altitude has a value if ceiling is set
  class Area
    include Validation
		
		# Area Description - Textual description of area.
		attr_accessor( :area_desc ) 
		# Expressed in feet above sea level 
    attr_accessor( :altitude )
		# Expressed in feet above sea level.
		attr_accessor( :ceiling )
		# Collection of Circle objects
    attr_reader( :circles )
		# Collection of Geocode objects
		attr_reader( :geocodes )
		# Collection of Polygon objects
		attr_reader( :polygons )

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

    def to_xml # :nodoc:
      self.to_xml_element.to_s
    end

		# Implements an equality operator for the Area object. Two Area objects are equal if all their attributes are equal.
		def ==( other )  
			comparison_attributes = lambda{ |area| [ area.area_desc, area.altitude, area.ceiling, area.circles, area.geocodes, area.polygons ]}
			comparison_attributes.call( self ) == comparison_attributes.call( other )
		end

    def self.from_xml_element( area_xml_element ) # :nodoc:
      area = RCAP::Area.new( :area_desc => RCAP.xpath_text( area_xml_element, AREA_DESC_XPATH ),
                            :altitude  => (( alt = RCAP.xpath_text( area_xml_element, ALTITUDE_XPATH )) ? alt.to_f : nil ),
                            :ceiling   => (( ceil = RCAP.xpath_text( area_xml_element, CEILING_XPATH )) ? ceil.to_f : nil ),
                            :circles   => RCAP.xpath_match( area_xml_element, RCAP::Circle::XPATH ).map{ |circle_element| RCAP::Circle.from_xml_element( circle_element )},
                            :geocodes  => RCAP.xpath_match( area_xml_element, RCAP::Geocode::XPATH ).map{ |geocode_element| RCAP::Geocode.from_xml_element( geocode_element )},
                            :polygons  => RCAP.xpath_match( area_xml_element, RCAP::Polygon::XPATH ).map{ |polygon_element| RCAP::Polygon.from_xml_element( polygon_element )})
			area
    end
  end
end
