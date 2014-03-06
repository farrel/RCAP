module RCAP
  module Base
    class Area
      include Validation

      # @return [String] Textual description of area.
      attr_accessor( :area_desc )
      # @return [Numeric] Expressed in feet above sea level
      attr_accessor( :altitude )
      # @return [Numeric] Expressed in feet above sea level.
      attr_accessor( :ceiling )
      # @return [Array<Circle>]
      attr_reader( :circles )
      # @return [Array<Geocode>]
      attr_reader( :geocodes )
      # @return [Array<Polygon>]
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

      # @example
      #   Area.new do |area|
      #     area.area_desc = 'Cape Town CVD'
      #   end
      def initialize
        @area_desc = nil
        @altitude  = nil
        @ceiling   = nil

        @circles  = []
        @geocodes = []
        @polygons = []
        yield( self ) if block_given?
      end

      # Creates a new {Polygon} object and adds it to the {#polygons} array.
      #
      # @return [Polygon]
      def add_polygon
        self.polygon_class.new.tap do |polygon|
          yield( polygon ) if block_given?
          @polygons << polygon
        end
      end

      # Creates a new {Circle} object and adds it to the {#circles} array.
      #
      # @return [Circle]
      def add_circle
        self.circle_class.new.tap do |circle|
          yield( circle ) if block_given?
          @circles << circle
        end
      end

      # Creates a new {Geocode} object and adds it to the {#geocodes} array.
      #
      # @return [Geocode]
      def add_geocode
        self.geocode_class.new do |geocode|
          yield( geocode ) if block_given?
          @geocodes << geocode
        end
      end

      def self.from_xml_element( area_xml_element )
        self.new do |area|
          area.area_desc = RCAP.xpath_text( area_xml_element, AREA_DESC_XPATH, area.xmlns )
          area.altitude  = RCAP.to_f_if_given( RCAP.xpath_text( area_xml_element, ALTITUDE_XPATH, area.xmlns ))
          area.ceiling   = RCAP.to_f_if_given( RCAP.xpath_text( area_xml_element, CEILING_XPATH, area.xmlns ))

          RCAP.xpath_match( area_xml_element, area.circle_class::XPATH, area.xmlns ).each do |circle_element|
            area.circles << area.circle_class.from_xml_element( circle_element )
          end

          RCAP.xpath_match( area_xml_element, area.geocode_class::XPATH, area.xmlns ).each do |geocode_element|
            area.geocodes  << area.geocode_class.from_xml_element( geocode_element )
          end

          RCAP.xpath_match( area_xml_element, area.polygon_class::XPATH, area.xmlns ).each do |polygon_element|
            area.polygons  << area.polygon_class.from_xml_element( polygon_element )
          end
        end
      end

      # @return [REXML::Element]
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

      # @return [String] XML representation of the Area
      def to_xml
        self.to_xml_element.to_s
      end

      # Implements an equality operator for the Area object. Two Area objects are equal if all their attributes are equal.
      #
      # @param [Area] other Area object to compare
      # @return [true,false]
      def ==( other )
        comparison_attributes = lambda{ |area| [ area.area_desc, area.altitude, area.ceiling, area.circles, area.geocodes, area.polygons ]}
        comparison_attributes.call( self ) == comparison_attributes.call( other )
      end

      # @return [String]
      def inspect
        area_inspect = "Area Description: #{ @area_desc }\n"+
                       "Polygons:\n"+
                       @polygons.map{ |polygon| "  " + polygon.inspect }.join("\n" )+"\n"+
                       "Circles:          #{ @circles.inspect }\n"+
                       "Geocodes:         #{ @geocodes.inspect }\n"
        RCAP.format_lines_for_inspect( 'AREA', area_inspect )
      end

      # Returns the area description
      #
      # @return [String]
      def to_s
        @area_desc
      end


      AREA_DESC_YAML = 'Area Description'
      ALTITUDE_YAML  = 'Altitude'
      CEILING_YAML   = 'Ceiling'
      CIRCLES_YAML   = 'Circles'
      GEOCODES_YAML  = 'Geocodes'
      POLYGONS_YAML  = 'Polygons'

      # @return [Hash] 
      def to_yaml_data
        RCAP.attribute_values_to_hash( [ AREA_DESC_YAML, @area_desc ],
                                       [ ALTITUDE_YAML,  @altitude ],
                                       [ CEILING_YAML,   @ceiling ],
                                       [ CIRCLES_YAML,   @circles.map{ |circle| circle.to_a }],
                                       [ GEOCODES_YAML,  @geocodes.inject({}){|h,geocode| h.merge( geocode.name => geocode.value )}],
                                       [ POLYGONS_YAML,  @polygons.map( &:to_yaml_data )])
      end

      # @return [String] YAML representation of object
      def to_yaml( options = {} )
        self.to_yaml_data.to_yaml( options )
      end

      # @param [Hash] area_yaml_data
      # @return [Area]
      def self.from_yaml_data( area_yaml_data )
        self.new do |area|
          area.area_desc = area_yaml_data[ AREA_DESC_YAML ]
          area.altitude  = area_yaml_data[ ALTITUDE_YAML ]
          area.ceiling   = area_yaml_data[ CEILING_YAML ]

          Array( area_yaml_data[ CIRCLES_YAML ]).each do |circle_yaml_data|
            area.circles << area.circle_class.from_yaml_data( circle_yaml_data )
          end

          Array( area_yaml_data[ GEOCODES_YAML ]).each do |name, value|
            area.add_geocode do |geocode|
              geocode.name = name
              geocode.value = value
            end
          end

          Array( area_yaml_data[ POLYGONS_YAML ]).each do |polyon_yaml_data|
            area.polygons << area.polygon_class.from_yaml_data( polyon_yaml_data )
          end
        end
      end

      AREA_DESC_KEY = 'area_desc'
      ALTITUDE_KEY  = 'altitude'
      CEILING_KEY   = 'ceiling'
      CIRCLES_KEY   = 'circles'
      GEOCODES_KEY  = 'geocodes'
      POLYGONS_KEY  = 'polygons'

      # @param [Hash] area_hash
      # @return [Area]
      def self.from_h( area_hash )
        self.new do |area|
          area.area_desc = area_hash[ AREA_DESC_KEY ]
          area.altitude  = area_hash[ ALTITUDE_KEY ]
          area.ceiling   = area_hash[ CEILING_KEY ]

          Array( area_hash[ CIRCLES_KEY ]).each do |circle_array|
            area.circles << area.circle_class.from_a( circle_array )
          end

          Array( area_hash[ GEOCODES_KEY ]).each do |geocode_hash|
            area.geocodes << area.geocode_class.from_h( geocode_hash )
          end

          Array( area_hash[ POLYGONS_KEY ]).each do |polygon_hash|
            area.polygons << area.polygon_class.from_h( polygon_hash )
          end
        end
      end

      # @return [Hash]
      def to_h
        RCAP.attribute_values_to_hash( [ AREA_DESC_KEY, @area_desc ],
                                       [ ALTITUDE_KEY,  @altitude ],
                                       [ CEILING_KEY,   @ceiling ],
                                       [ CIRCLES_KEY,   @circles.map{ |circle| circle.to_a }],
                                       [ GEOCODES_KEY,  @geocodes.map{ |geocode| geocode.to_h }],
                                       [ POLYGONS_KEY,  @polygons.map{ |polygon| polygon.to_h }])
      end
    end
  end
end
