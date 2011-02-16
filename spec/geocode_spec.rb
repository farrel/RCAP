require 'spec_helper'

describe( RCAP::Geocode ) do
  context( 'when initialised' ) do
    context( 'from XML' ) do
      before( :each ) do
        @original_geocode = RCAP::Geocode.new( :name => 'name', :value => 'value' )
        @alert = RCAP::Alert.new( :infos => RCAP::Info.new( :areas => RCAP::Area.new( :geocodes => @original_geocode )))
        @xml_string = @alert.to_xml
        @xml_document = REXML::Document.new( @xml_string )
        @info_xml_element = RCAP.xpath_first( @xml_document.root, RCAP::Info::XPATH )
        @area_xml_element = RCAP.xpath_first( @info_xml_element, RCAP::Area::XPATH )
        @geocode_xml_element = RCAP.xpath_first( @area_xml_element, RCAP::Geocode::XPATH )
        @geocode = RCAP::Geocode.from_xml_element( @geocode_xml_element )
      end

      it( 'should parse the name correctly' ) do
        @geocode.name.should == @original_geocode.name
      end

      it( 'should parse the value correctly' ) do
        @geocode.value.should == @original_geocode.value
      end
    end
  end

  context( 'when exported' ) do
    before( :each ) do
      @geocode = RCAP::Geocode.new( :name => 'name', :value => 'value' )
    end

    context( 'to a hash' ) do
      it( 'should export correctly' ) do
        @geocode.to_h.should == { 'name' => 'value' }
      end
    end
  end
end
