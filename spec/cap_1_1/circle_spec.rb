require 'spec_helper'

describe( RCAP::CAP_1_1::Circle ) do
  describe( 'should not be valid if' ) do
    before( :each ) do
      @circle = RCAP::CAP_1_1::Circle.new( :lattitude => 0, :longitude => 0 , :radius => 1 )
      @circle.should( be_valid )
    end

    it( 'does not have a lattitude defined' ) do
      @circle.lattitude = nil
      @circle.should_not( be_valid )
    end

    it( 'does not have a longitude defined' ) do
      @circle.longitude = nil
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
        @original_circle = RCAP::CAP_1_1::Circle.new( :radius => 10.5,
                                             :lattitude => 30, :longitude => 60 )
        @alert = RCAP::CAP_1_1::Alert.new( :infos => RCAP::CAP_1_1::Info.new( :areas => RCAP::CAP_1_1::Area.new( :circles => @original_circle )))
        @xml_string = @alert.to_xml
        @xml_document = REXML::Document.new( @xml_string )
        @info_element = RCAP.xpath_first( @xml_document.root, RCAP::CAP_1_1::Info::XPATH, RCAP::CAP_1_1::Alert::XMLNS )
        @area_element = RCAP.xpath_first( @info_element, RCAP::CAP_1_1::Area::XPATH, RCAP::CAP_1_1::Alert::XMLNS )
        @circle_element = RCAP.xpath_first( @area_element, RCAP::CAP_1_1::Circle::XPATH, RCAP::CAP_1_1::Alert::XMLNS )
        @circle = RCAP::CAP_1_1::Circle.from_xml_element( @circle_element )
      end

      it( 'should parse the radius correctly' ) do
        @circle.radius.should == @original_circle.radius
      end

      it( 'should parse the lattitude and longitude correctly' ) do
        @circle.lattitude.should == @original_circle.lattitude
        @circle.longitude.should == @original_circle.longitude
      end
    end

    context( 'from a hash' ) do
      before( :each ) do
        @original_circle = RCAP::CAP_1_1::Circle.new( :radius => 10.5, :lattitude => 30, :longitude => 60 )
        @circle = RCAP::CAP_1_1::Circle.from_h( @original_circle.to_h )
      end

      it( 'should set the radius correctly' ) do
        @circle.radius.should == @original_circle.radius
      end

      it( 'should parse the lattitude and longitude correctly' ) do
        @circle.lattitude.should == @original_circle.lattitude
        @circle.longitude.should == @original_circle.longitude
      end
    end
  end

  context( 'when exported' ) do
    before( :each ) do
      @circle = RCAP::CAP_1_1::Circle.new( :radius => 10.5, :lattitude => 30, :longitude => 60 )
    end

    context( 'to hash' ) do
      it( 'should be correct' ) do
        @circle.to_h.should == { 'radius' => 10.5, 'lattitude' => 30, 'longitude' => 60 }
      end
    end
  end
end
