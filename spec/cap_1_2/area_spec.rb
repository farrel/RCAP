require 'spec_helper'

describe( RCAP::CAP_1_2::Area ) do
  before( :each ) do
    @area_builder = lambda do |area|
      area.area_desc = 'Area Description'
      area.altitude  = 100
      area.ceiling   = 200

      area.add_circle do |circle|
        circle.lattitude = 0
        circle.longitude = 0
        circle.radius = 100
      end

      area.add_geocode do |geocode|
        geocode.name = 'name'
        geocode.value = 'value'
      end

      area.add_polygon.add_point do |point|
        point.lattitude = 1
        point.longitude = 2
      end
    end
  end
  context( 'on initialisation' ) do
    before( :each ) do
      @area = RCAP::CAP_1_2::Area.new
      @original_area = RCAP::CAP_1_2::Area.new( &@area_builder )
    end

    # Atomic
    it( 'should not have a area_desc' ){ @area.area_desc.should( be_nil )}
    it( 'should not have a altitude' ){ @area.altitude.should( be_nil )}
    it( 'should not have a ceiling' ){ @area.ceiling.should( be_nil )}

    # Group
    it( 'should have an empty polygons' ){ @area.polygons.should( be_empty )}
    it( 'should have an empty circles' ){ @area.circles.should( be_empty )}
    it( 'should have an empty geocodes' ){ @area.geocodes.should( be_empty )}

    shared_examples_for( "it can parse into a CAP 1.2 Area object" ) do
      it( 'should parse the area_desc correctly' ) do
        @area.area_desc.should == @original_area.area_desc
      end

      it( 'should parse the altitude correctly' ) do
        @area.altitude.should == @original_area.altitude
      end

      it( 'should parse the ceiling correctly' ) do
        @area.ceiling.should == @original_area.ceiling
      end

      it( 'should parse the circles correctly' ) do
        @area.circles.should == @original_area.circles
      end

      it( 'should parse the geocodes correctly' ) do
        @area.geocodes.should == @original_area.geocodes
      end

      it( 'should parse the polygons correctly' ) do
        @area.polygons.should == @original_area.polygons
      end
    end

    context( 'from XML' ) do
      before( :each ) do
        @alert = RCAP::CAP_1_2::Alert.new
        @alert.add_info.add_area( &@area_builder )
        @xml_string = @alert.to_xml
        @xml_document = REXML::Document.new( @xml_string )
        @info_xml_element = RCAP.xpath_first( @xml_document.root, RCAP::CAP_1_2::Info::XPATH, RCAP::CAP_1_2::Alert::XMLNS )
        @area_xml_element = RCAP.xpath_first( @info_xml_element, RCAP::CAP_1_2::Area::XPATH, RCAP::CAP_1_2::Alert::XMLNS )
        @area = RCAP::CAP_1_2::Area.from_xml_element( @area_xml_element )
      end

      it_should_behave_like( "it can parse into a CAP 1.2 Area object" )
    end

    context( 'from YAML Data' ) do
      before( :each ) do
        @area = RCAP::CAP_1_2::Area.from_yaml_data( YAML.load( @original_area.to_yaml ))
      end

      it_should_behave_like( "it can parse into a CAP 1.2 Area object" )
    end

    context( 'from a hash' ) do
      before( :each ) do
        @area = RCAP::CAP_1_2::Area.from_h( @original_area.to_h )
      end

      it_should_behave_like( "it can parse into a CAP 1.2 Area object" )
    end
  end

  context( 'when exported' ) do
    before( :each ) do
      @area = RCAP::CAP_1_2::Area.new( &@area_builder )
    end

    context( 'to a hash' ) do
      before( :each ) do
        @area_hash = @area.to_h
      end

      it( 'should export the area description correctly' ) do
        @area_hash[ RCAP::CAP_1_2::Area::AREA_DESC_KEY ].should == @area.area_desc
      end

      it( 'should export the altitude correctly' ) do
        @area_hash[ RCAP::CAP_1_2::Area::ALTITUDE_KEY ].should == @area.altitude
      end

      it( 'should set the ceiling correctly' ) do
        @area_hash[ RCAP::CAP_1_2::Area::CEILING_KEY ].should == @area.ceiling
      end

      it( 'should export the circles correctly' ) do
        @area_hash[ RCAP::CAP_1_2::Area::CIRCLES_KEY ].should == @area.circles.map{ |circle| circle.to_a }
      end

      it( 'should export the geocodes correctly' ) do
        @area_hash[ RCAP::CAP_1_2::Area::GEOCODES_KEY ].should == @area.geocodes.map{ |geocode| geocode.to_h }
      end

      it( 'should export the polygons correctly' ) do
        @area_hash[ RCAP::CAP_1_2::Area::POLYGONS_KEY ].should == @area.polygons.map{ |polygon| polygon.to_h }
      end
    end
  end

  context( 'is not valid if' ) do
    before( :each ) do
      @area = RCAP::CAP_1_2::Area.new do |area|
        area.area_desc = "Cape Town Metropole"
      end
      @area.should( be_valid )
    end

    it( 'does not have an area descrtiption (area_desc)') do
      @area.area_desc = nil
      @area.should_not( be_valid )
    end

    it( 'has a ceiling defined but no altitude' ) do
      @area.ceiling = 1
      @area.altitude = nil
      @area.should_not( be_valid )
    end

    context( 'it contains circles and it' ) do
      before( :each ) do
        @area.add_circle do |circle|
          circle.lattitude = 0
          circle.longitude = 0
          circle.radius = 1
        end
        @area.should( be_valid )
      end

      it( 'has an invalid circle' ) do
        @area.circles.first.lattitude = nil
        @area.should_not( be_valid )
      end
    end

    context( 'it contains polygons and it' ) do
      before( :each ) do
        @polygon = @area.add_polygon do |polygon|
          [ 0, 1, 2, 0 ].each do |coordinate|
            polygon.add_point do |point|
              point.lattitude = coordinate
              point.longitude = coordinate
            end
          end
        end
        @area.should( be_valid )
      end

      it( 'has an invalid polygon' ) do
        @polygon.points.first.lattitude = nil
        @area.should_not( be_valid )
      end
    end

    context( 'it contains geocodes and it' ) do
      before( :each ) do
        @geocode = @area.add_geocode do |geocode|
          geocode.name  = 'name'
          geocode.value = 'value'
        end

        @area.should( be_valid )
      end

      it( 'has an invalid geocode' ) do
        @geocode.value = nil
        @area.should_not( be_valid )
      end
    end
  end

  describe( 'instance methods' ) do
    before( :each ) do
      @area = RCAP::CAP_1_2::Area.new
    end

    describe( '#add_polygon' ) do
      before( :each ) do
        @polygon = @area.add_polygon
      end

      it( 'should return a CAP 1.1 Polygon' ) do
        @polygon.class.should == RCAP::CAP_1_2::Polygon
      end

      it( 'should add a Polygon to the polygons attribute' ) do
        @area.polygons.size.should == 1
      end
    end

    describe( '#add_circle' ) do
      before( :each ) do
        @circle = @area.add_circle do |circle|
          circle.lattitude = 1
          circle.longitude = 1
          circle.radius = 1
        end
      end

      it( 'should return a CAP 1.1 Circle' ) do
        @circle.class.should == RCAP::CAP_1_2::Circle
        @circle.lattitude.should == 1
        @circle.longitude.should == 1
        @circle.radius.should == 1
      end

      it( 'should add a circle to the circles attribute' ) do
        @area.circles.size.should == 1
      end
    end

    describe( '#add_geocode' ) do
      before( :each ) do
        @geocode = @area.add_geocode do |geocode|
          geocode.name = 'Geocode'
          geocode.value = '123'
        end
      end

      it( 'should return a CAP 1.1 Geocode' ) do
        @geocode.class.should == RCAP::CAP_1_2::Geocode
        @geocode.name.should == 'Geocode'
        @geocode.value.should == '123'
      end

      it( 'should add a geocode to the geocodes attribute' ) do
        @area.geocodes.size.should == 1
      end
    end
  end
end
