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
      xml_element.add_element( CEILING_ELEMENT_NAME ).add_text( @ceiling.to_s )   unless self.altitude.blank?
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

		def inspect # :nodoc:
      area_inspect =  <<EOF
Area Description: #{ self.area_desc }
Polygons:
#{ self.polygons.map{ |polygon| "  " + polygon.inspect }.join("\n" )}
Circles:          #{ self.circles.inspect }
Geocodes:         #{ self.geocodes.inspect }
EOF
      RCAP.format_lines_for_inspect( 'AREA', area_inspect )
		end

		# Returns a string representation of the area of the form
		#  area_desc
    def to_s 
      self.area_desc
    end

    def self.from_xml_element( area_xml_element ) # :nodoc:
      RCAP::Area.new( :area_desc => RCAP.xpath_text( area_xml_element, AREA_DESC_XPATH ),
											:altitude  => (( alt = RCAP.xpath_text( area_xml_element, ALTITUDE_XPATH )) ? alt.to_f : nil ),
											:ceiling   => (( ceil = RCAP.xpath_text( area_xml_element, CEILING_XPATH )) ? ceil.to_f : nil ),
											:circles   => RCAP.xpath_match( area_xml_element, RCAP::Circle::XPATH ).map{ |circle_element| RCAP::Circle.from_xml_element( circle_element )},
											:geocodes  => RCAP.xpath_match( area_xml_element, RCAP::Geocode::XPATH ).map{ |geocode_element| RCAP::Geocode.from_xml_element( geocode_element )},
											:polygons  => RCAP.xpath_match( area_xml_element, RCAP::Polygon::XPATH ).map{ |polygon_element| RCAP::Polygon.from_xml_element( polygon_element )})
    end

     AREA_DESC_YAML = 'Area Description' # :nodoc:
     ALTITUDE_YAML  = 'Altitude'         # :nodoc:
     CEILING_YAML   = 'Ceiling'          # :nodoc:
     CIRCLES_YAML   = 'Circles'          # :nodoc:
     GEOCODES_YAML  = 'Geocodes'         # :nodoc:
     POLYGONS_YAML  = 'Polygons'         # :nodoc:

     def to_yaml( options = {} ) # :nodoc:
       circles_yaml = self.circles.map{ |circle| [[ circle.point.lattitude, circle.point.longitude ], circle.radius ]}
       def circles_yaml.to_yaml_style; :inline; end

       RCAP.attribute_values_to_yaml_hash(
         [ AREA_DESC_YAML,  self.area_desc ],
         [ ALTITUDE_YAML,   self.altitude ],
         [ CEILING_YAML,    self.ceiling ],
         [ CIRCLES_YAML,    circles_yaml ],
         [ GEOCODES_YAML,   self.geocodes.inject({}){|h,geocode| h.merge( geocode.name => geocode.value )}],
         [ POLYGONS_YAML,   self.polygons ]
       ).to_yaml( options )
     end

     def from_yaml_data( area_yaml_data )  # :nodoc:
       Area.new(
         :area_desc => area_yaml_data[ AREA_DESC_YAML ],
         :altitude  => area_yaml_data[ ALTITUDE_YAML ],
         :ceiling   => area_yaml_data[ CEILING_YAML ],
         :circles   => Array( area_yaml_data[ CIRCLES_YAML ]).map{ |circle_yaml_data| RCAP::Circle.from_yaml_data( circle_yaml_data )},
         :geocodes  => Array( area_yaml_data[ GEOCODES_YAML ]).map{ |name, value| RCAP::Geocode.new( :name => name, :value => value )},
         :polygons  => Array( area_yaml_data[ POLYGONS_YAML ]).map{ |polyon_yaml_data| RCAP::Polygon.from_yaml_data( polyon_yaml_data )}
       )
     end

     def to_h
       { 'area_desc' => self.area_desc,
         'altitude'  => self.altitude,
         'ceiling'   => self.ceiling,
         'circles'   => self.circles.map{ |circle| circle.to_h },
         'geocodes'  => self.geocodes.map{ |geocode| geocode.to_h },
         'polygons'  => self.polygons.map{ |polygon| polygon.to_h }}
     end

     def self.from_h( area_hash )
       self.new(
        :area_desc => area_hash[ 'area_desc' ],
        :altitude  => area_hash[ 'altitude' ],
        :ceiling   => area_hash[ 'ceiling' ],
        :circles   => area_hash[ 'circles' ].map{ |circle_hash| RCAP::Circle.from_h( circle_hash )},
        :geocodes  => area_hash[ 'geocodes' ].map{ |geocode_hash| RCAP::Geocode.from_h( geocode_hash )},
        :polygons  => area_hash[ 'polygons' ].map{ |polygon_hash| RCAP::Polygon.from_h( polygon_hash )})
     end
  end
end
