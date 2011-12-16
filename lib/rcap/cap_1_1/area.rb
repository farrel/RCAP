module RCAP
  module CAP_1_1
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
      validates_collection_of( :circles, :geocodes, :polygons, allow_empty: true )
      validates_dependency_of( :ceiling, on: :altitude )

      XML_ELEMENT_NAME       = 'area'     
      AREA_DESC_ELEMENT_NAME = 'areaDesc' 
      ALTITUDE_ELEMENT_NAME  = 'altitude' 
      CEILING_ELEMENT_NAME   = 'ceiling'  

      XPATH           = "cap:#{ XML_ELEMENT_NAME }"       
      AREA_DESC_XPATH = "cap:#{ AREA_DESC_ELEMENT_NAME }" 
      ALTITUDE_XPATH  = "cap:#{ ALTITUDE_ELEMENT_NAME }"  
      CEILING_XPATH   = "cap:#{ CEILING_ELEMENT_NAME }"   

      def initialize( attributes = {})
        @area_desc = attributes[ :area_desc ]
        @altitude  = attributes[ :altitude ]
        @ceiling   = attributes[ :ceiling ]
        @circles   = Array( attributes[ :circles ])
        @geocodes  = Array( attributes[ :geocodes ])
        @polygons  = Array( attributes[ :polygons ])
      end

      # Creates a new Polygon object and adds it to the polygons array. The
      # polygon_attributes are passed as a parameter to Polygon.new.
      def add_polygon( polygon_attributes = {})
        polygon = Polygon.new( polygon_attributes )
        @polygons << polygon
        polygon
      end

      # Creates a new Circle object and adds it to the circles array. The
      # circle_attributes are passed as a parameter to Circle.new.
      def add_circle( circle_attributes = {})
        circle = Circle.new( circle_attributes )
        @circles << circle
        circle
      end

      # Creates a new Geocode object and adds it to the geocodes array. The
      # geocode_attributes are passed as a parameter to Geocode.new.
      def add_geocode( geocode_attributes = {})
        geocode = Geocode.new( geocode_attributes )
        @geocodes << geocode
        geocode
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
        xml_element.add_element( ALTITUDE_ELEMENT_NAME ).add_text( @altitude.to_s ) unless @altitude.blank?
        xml_element.add_element( CEILING_ELEMENT_NAME ).add_text( @ceiling.to_s )   unless @altitude.blank?
        xml_element
      end

      def to_xml 
        self.to_xml_element.to_s
      end

      # Implements an equality operator for the Area object. Two Area objects are equal if all their attributes are equal.
      def ==( other )
        comparison_attributes = lambda{ |area| [ area.area_desc, area.altitude, area.ceiling, area.circles, area.geocodes, area.polygons ]}
        comparison_attributes.call( self ) == comparison_attributes.call( other )
      end

      def inspect 
        area_inspect = "Area Description: #{ @area_desc }\n"+
                       "Polygons:\n"+
                       @polygons.map{ |polygon| "  " + polygon.inspect }.join("\n" )+"\n"+
                       "Circles:          #{ @circles.inspect }\n"+
                       "Geocodes:         #{ @geocodes.inspect }\n"
        RCAP.format_lines_for_inspect( 'AREA', area_inspect )
      end

      # Returns a string representation of the area of the form
      #  area_desc
      def to_s
        @area_desc
      end

      def self.from_xml_element( area_xml_element ) 
        self.new( :area_desc => RCAP.xpath_text( area_xml_element, AREA_DESC_XPATH, Alert::XMLNS ),
                 :altitude  => (( alt = RCAP.xpath_text( area_xml_element, ALTITUDE_XPATH, Alert::XMLNS )) ? alt.to_f : nil ),
                 :ceiling   => (( ceil = RCAP.xpath_text( area_xml_element, CEILING_XPATH, Alert::XMLNS )) ? ceil.to_f : nil ),
                 :circles   => RCAP.xpath_match( area_xml_element, Circle::XPATH, Alert::XMLNS ).map{ |circle_element| Circle.from_xml_element( circle_element )},
                 :geocodes  => RCAP.xpath_match( area_xml_element, Geocode::XPATH, Alert::XMLNS ).map{ |geocode_element| Geocode.from_xml_element( geocode_element )},
                 :polygons  => RCAP.xpath_match( area_xml_element, Polygon::XPATH, Alert::XMLNS ).map{ |polygon_element| Polygon.from_xml_element( polygon_element )})
      end

      AREA_DESC_YAML = 'Area Description' 
      ALTITUDE_YAML  = 'Altitude'         
      CEILING_YAML   = 'Ceiling'          
      CIRCLES_YAML   = 'Circles'          
      GEOCODES_YAML  = 'Geocodes'         
      POLYGONS_YAML  = 'Polygons'         

      def to_yaml( options = {} ) 
        RCAP.attribute_values_to_hash(
          [ AREA_DESC_YAML, @area_desc ],
          [ ALTITUDE_YAML,  @altitude ],
          [ CEILING_YAML,   @ceiling ],
          [ CIRCLES_YAML,   @circles.map{ |circle| [ circle.lattitude, circle.longitude, circle.radius ]}],
          [ GEOCODES_YAML,  @geocodes.inject({}){|h,geocode| h.merge( geocode.name => geocode.value )}],
          [ POLYGONS_YAML,  @polygons ]
        ).to_yaml( options )
      end

      def self.from_yaml_data( area_yaml_data )  
        self.new( :area_desc => area_yaml_data[ AREA_DESC_YAML ],
                  :altitude  => area_yaml_data[ ALTITUDE_YAML ],
                  :ceiling   => area_yaml_data[ CEILING_YAML ],
                  :circles   => Array( area_yaml_data[ CIRCLES_YAML ]).map{ |circle_yaml_data| Circle.from_yaml_data( circle_yaml_data )},
                  :geocodes  => Array( area_yaml_data[ GEOCODES_YAML ]).map{ |name, value| Geocode.new( :name => name, :value => value )},
                  :polygons  => Array( area_yaml_data[ POLYGONS_YAML ]).map{ |polyon_yaml_data| Polygon.from_yaml_data( polyon_yaml_data )})
      end

      AREA_DESC_KEY = 'area_desc'  
      ALTITUDE_KEY  = 'altitude'   
      CEILING_KEY   = 'ceiling'    
      CIRCLES_KEY   = 'circles'    
      GEOCODES_KEY  = 'geocodes'   
      POLYGONS_KEY  = 'polygons'   

      def to_h 
        RCAP.attribute_values_to_hash( [ AREA_DESC_KEY, @area_desc ],
                                       [ ALTITUDE_KEY, @altitude ],
                                       [ CEILING_KEY, @ceiling ],
                                       [ CIRCLES_KEY, @circles.map{ |circle| circle.to_h } ],
                                       [ GEOCODES_KEY, @geocodes.map{ |geocode| geocode.to_h } ],
                                       [ POLYGONS_KEY, @polygons.map{ |polygon| polygon.to_h } ])
      end

      def self.from_h( area_hash ) 
        self.new(
          :area_desc => area_hash[ AREA_DESC_KEY ],
          :altitude  => area_hash[ ALTITUDE_KEY ],
          :ceiling   => area_hash[ CEILING_KEY ],
          :circles   => Array( area_hash[ CIRCLES_KEY ]).map{ |circle_hash| Circle.from_h( circle_hash )},
          :geocodes  => Array( area_hash[ GEOCODES_KEY ]).map{ |geocode_hash| Geocode.from_h( geocode_hash )},
          :polygons  => Array( area_hash[ POLYGONS_KEY ]).map{ |polygon_hash| Polygon.from_h( polygon_hash )})
      end
    end
  end
end
