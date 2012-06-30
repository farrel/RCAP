require 'spec_helper'

describe( RCAP::CAP_1_2::EventCode ) do
  context( 'when initialised' ) do
    context( 'from XML' ) do
      before( :each ) do
        @original_event_code = RCAP::CAP_1_2::EventCode.new( :name => 'name', :value => 'value' )
        @alert = RCAP::CAP_1_2::Alert.new
        @alert.add_info.event_codes <<  @original_event_code 
        @xml_string = @alert.to_xml
        @xml_document = REXML::Document.new( @xml_string )
        @info_xml_element = RCAP.xpath_first( @xml_document.root, RCAP::CAP_1_2::Info::XPATH, RCAP::CAP_1_2::Alert::XMLNS )
        @event_code_xml_element = RCAP.xpath_first( @info_xml_element, RCAP::CAP_1_2::EventCode::XPATH, RCAP::CAP_1_2::Alert::XMLNS )
        @event_code = RCAP::CAP_1_2::EventCode.from_xml_element( @event_code_xml_element )
      end

      it( 'should parse into the correct class' ) do
        @event_code.class.should == RCAP::CAP_1_2::EventCode
      end

      it( 'should parse the name correctly' ) do
        @event_code.name.should == @original_event_code.name
      end

      it( 'should parse the value correctly' ) do
        @event_code.value.should == @original_event_code.value
      end
    end
  end

  context( 'when exported' ) do
    before( :each ) do
      @event_code = RCAP::CAP_1_2::EventCode.new( :name => 'name', :value => 'value' )
    end

    context( 'to a hash' ) do
      it( 'should export correctly' ) do
        @event_code.to_h.should == { 'name' => 'value' }
      end
    end
  end
end

