module RCAP
  module CAP_1_1

    # An Area object is valid if
    # * it has an area description
    # * all Circle objects contained in circles are valid
    # * all Geocode objects contained in geocodes are valid
    # * all Polygon objects contained in polygons are valid
    # * altitude has a value if ceiling is set
    class Area < RCAP::Base::Area
      
      # Creates a new {Polygon} object and adds it to the {#polygons} array.
      #
      # @see Polygon#initialize
      # @param [Hash] polygon_attributes see {Polygon#initialize}
      # @return [Polygon]
      def add_polygon( polygon_attributes = {})
        polygon = Polygon.new( polygon_attributes )
        @polygons << polygon
        polygon
      end

      # Creates a new {Circle} object and adds it to the {#circles} array.
      #
      # @param [Hash] circle_attributes
      # @return [Circle]
      def add_circle( circle_attributes = {})
        circle = Circle.new( circle_attributes )
        @circles << circle
        circle
      end

      # Creates a new {Geocode} object and adds it to the {#geocodes} array.
      #
      # @param [Hash] geocode_attributes
      # @return [Geocode]
      def add_geocode( geocode_attributes = {})
        geocode = Geocode.new( geocode_attributes )
        @geocodes << geocode
        geocode
      end

      # @param [REXML::Element] area_xml_element
      # @return [Area]
      def self.from_xml_element( area_xml_element ) 
        self.new( :area_desc => RCAP.xpath_text( area_xml_element, AREA_DESC_XPATH, Alert::XMLNS ),
                  :altitude  => (( alt = RCAP.xpath_text( area_xml_element, ALTITUDE_XPATH, Alert::XMLNS )) ? alt.to_f : nil ),
                  :ceiling   => (( ceil = RCAP.xpath_text( area_xml_element, CEILING_XPATH, Alert::XMLNS )) ? ceil.to_f : nil ),
                  :circles   => RCAP.xpath_match( area_xml_element, Circle::XPATH, Alert::XMLNS ).map{ |circle_element| Circle.from_xml_element( circle_element )},
                  :geocodes  => RCAP.xpath_match( area_xml_element, Geocode::XPATH, Alert::XMLNS ).map{ |geocode_element| Geocode.from_xml_element( geocode_element )},
                  :polygons  => RCAP.xpath_match( area_xml_element, Polygon::XPATH, Alert::XMLNS ).map{ |polygon_element| Polygon.from_xml_element( polygon_element )})
      end

      # @param [Hash] area_yaml_data
      # @return [Area]
      def self.from_yaml_data( area_yaml_data )  
        self.new( :area_desc => area_yaml_data[ AREA_DESC_YAML ],
                  :altitude  => area_yaml_data[ ALTITUDE_YAML ],
                  :ceiling   => area_yaml_data[ CEILING_YAML ],
                  :circles   => Array( area_yaml_data[ CIRCLES_YAML ]).map{ |circle_yaml_data| Circle.from_yaml_data( circle_yaml_data )},
                  :geocodes  => Array( area_yaml_data[ GEOCODES_YAML ]).map{ |name, value| Geocode.new( :name => name, :value => value )},
                  :polygons  => Array( area_yaml_data[ POLYGONS_YAML ]).map{ |polyon_yaml_data| Polygon.from_yaml_data( polyon_yaml_data )})
      end

      # @param [Hash] area_hash
      # @return [Area]
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
