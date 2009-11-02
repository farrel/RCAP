require 'spec/spec_helper'

describe( CAP::Polygon ) do
  describe( 'is not valid if it' ) do
    before( :each ) do
      @polygon = CAP::Polygon.new
      3.times do
        @polygon.points << CAP::Point.new( :lattitude => 0, :longitude => 0 )
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
        @original_polygon = CAP::Polygon.new( :points => Array.new(3){|i| CAP::Point.new( :lattitude => i, :longitude => i )})
        @alert = CAP::Alert.new( :infos => CAP::Info.new( :areas => CAP::Area.new( :polygons => @original_polygon )))
        @xml_string = @alert.to_xml
        @xml_document = REXML::Document.new( @xml_string )
				@info_element = CAP.xpath_first( @xml_document.root, CAP::Info::XPATH )
				@area_element = CAP.xpath_first( @info_element, CAP::Area::XPATH )
        @polygon_element = CAP.xpath_first( @area_element, CAP::Polygon::XPATH )
        @polygon = CAP::Polygon.from_xml_element( @polygon_element )
      end

      it( 'should parse all the points' ) do
        @polygon.points.zip( @original_polygon.points ).each do |point, original_point|
          point.lattitude.should == original_point.lattitude
          point.longitude.should == original_point.longitude
        end
      end
    end
  end
end
