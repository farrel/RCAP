require 'spec_helper'

describe( RCAP::CAP_1_2::Polygon ) do
  describe( 'is not valid if it' ) do
    before( :each ) do
      @polygon = RCAP::CAP_1_2::Polygon.new
      3.times do
        @polygon.points << RCAP::CAP_1_2::Point.new( :lattitude => 0, :longitude => 0 )
      end
      @polygon.should( be_valid )
    end

    it( 'does not have any points' ) do
      @polygon.points.clear
      @polygon.should_not( be_valid )
    end

    it( 'does not have a valid collection of points' ) do
      @polygon.points.first.lattitude = nil
      @polygon.should_not( be_valid )
    end
  end

  context( 'on initialization' ) do
    context( 'from XML' ) do
      before( :each ) do
        @original_polygon = RCAP::CAP_1_2::Polygon.new( :points => Array.new(3){|i| RCAP::CAP_1_2::Point.new( :lattitude => i, :longitude => i )})
        @alert = RCAP::CAP_1_2::Alert.new( :infos => RCAP::CAP_1_2::Info.new( :areas => RCAP::CAP_1_2::Area.new( :polygons => @original_polygon )))
        @xml_string = @alert.to_xml
        @xml_document = REXML::Document.new( @xml_string )
				@info_element = RCAP.xpath_first( @xml_document.root, RCAP::CAP_1_2::Info::XPATH, RCAP::CAP_1_2::Alert::XMLNS )
				@area_element = RCAP.xpath_first( @info_element, RCAP::CAP_1_2::Area::XPATH, RCAP::CAP_1_2::Alert::XMLNS )
        @polygon_element = RCAP.xpath_first( @area_element, RCAP::CAP_1_2::Polygon::XPATH, RCAP::CAP_1_2::Alert::XMLNS )
        @polygon = RCAP::CAP_1_2::Polygon.from_xml_element( @polygon_element )
      end

      it( 'should parse all the points' ) do
        @polygon.points.zip( @original_polygon.points ).each do |point, original_point|
          point.lattitude.should == original_point.lattitude
          point.longitude.should == original_point.longitude
        end
      end
    end

    context( 'from a hash' ) do
      before( :each ) do
        @polygon = RCAP::CAP_1_2::Polygon.new( :points => Array.new(3){|i| RCAP::CAP_1_2::Point.new( :lattitude => i, :longitude => i )})
      end

      it( 'should load all the points' ) do
        @new_polygon = RCAP::CAP_1_2::Polygon.from_h( @polygon.to_h )
        @new_polygon.points.should == @polygon.points
      end
    end
  end
  
  context( 'when exported' ) do
    before( :each ) do
      @polygon = RCAP::CAP_1_2::Polygon.new( :points => Array.new(3){|i| RCAP::CAP_1_2::Point.new( :lattitude => i, :longitude => i )})
    end

    context( 'to a hash' ) do
      it( 'should export correctly' ) do
        @polygon.to_h.should == { RCAP::CAP_1_2::Polygon::POINTS_KEY => @polygon.points.map{ |point| point.to_h }}
      end
    end
  end
end
