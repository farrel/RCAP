require 'spec_helper'

describe(RCAP::CAP_1_1::EventCode) do
  context('when initialised') do
    context('from XML') do
      before(:each) do
        @alert = RCAP::CAP_1_1::Alert.new do |alert|
          alert.add_info.add_event_code do |event_code|
            event_code.name = 'name'
            event_code.value = 'value'
          end
        end
        @original_event_code = @alert.infos.first.event_codes.first
        @xml_string = @alert.to_xml
        @xml_document = REXML::Document.new(@xml_string)
        @info_xml_element = RCAP.xpath_first(@xml_document.root, RCAP::CAP_1_1::Info::XPATH, RCAP::CAP_1_1::Alert::XMLNS)
        @event_code_xml_element = RCAP.xpath_first(@info_xml_element, RCAP::CAP_1_1::EventCode::XPATH, RCAP::CAP_1_1::Alert::XMLNS)
        @event_code = RCAP::CAP_1_1::EventCode.from_xml_element(@event_code_xml_element)
      end

      it('should parse into the correct class') do
        @event_code.class.should == RCAP::CAP_1_1::EventCode
      end

      it('should parse the name correctly') do
        @event_code.name.should == @original_event_code.name
      end

      it('should parse the value correctly') do
        @event_code.value.should == @original_event_code.value
      end
    end
  end

  context('when exported') do
    before(:each) do
      @event_code = RCAP::CAP_1_1::EventCode.new do |event_code|
        event_code.name = 'name'
        event_code.value = 'value'
      end
    end

    context('to a hash') do
      it('should export correctly') do
        @event_code.to_h.should == { 'name' => 'value' }
      end
    end
  end
end
