require 'spec/spec_helper'

describe( RCAP::Circle ) do
  describe( 'should not be valid if' ) do
    before( :each ) do
      @circle = RCAP::Circle.new( :point => RCAP::Point.new( :lattitude => 0, :longitude => 0 ), :radius => 1 )
      @circle.should( be_valid )
    end

    it( 'does not have a point defined' ) do
      @circle.point = nil
      @circle.should_not( be_valid )
    end
    
    it( 'does not have a valid point' ) do
      @circle.point.longitude = nil
      @circle.should_not( be_valid )
    end
    it( 'does not have a radius defined' ) do
      @circle.radius = nil
      @circle.should_not( be_valid )
    end

    it( 'does not have a numeric radius' ) do
      @circle.radius = "not a number"
      @circle.should_not( be_valid )
    end

    it( 'does not have a positive radius' ) do
      @circle.radius = -1
      @circle.should_not( be_valid )
    end
  end

	context( 'on initialisation' ) do
		context( 'from XML' ) do
			before( :each ) do
				@original_circle = RCAP::Circle.new( :radius => 10.5,
																					 :point => RCAP::Point.new( :lattitude => 30, :longitude => 60 ))
				@alert = RCAP::Alert.new( :infos => RCAP::Info.new( :areas => RCAP::Area.new( :circles => @original_circle )))
				@xml_string = @alert.to_xml
        @xml_document = REXML::Document.new( @xml_string )
				@info_element = RCAP.xpath_first( @xml_document.root, RCAP::Info::XPATH )
				@area_element = RCAP.xpath_first( @info_element, RCAP::Area::XPATH )
				@circle_element = RCAP.xpath_first( @area_element, RCAP::Circle::XPATH )
				@circle = RCAP::Circle.from_xml_element( @circle_element )
			end

			it( 'should parse the radius correctly' ) do
				@circle.radius.should == @original_circle.radius
			end

			it( 'should parse the point correctly' ) do
				@circle.point.lattitude.should == @original_circle.point.lattitude
				@circle.point.longitude.should == @original_circle.point.longitude
			end
		end
	end
end
