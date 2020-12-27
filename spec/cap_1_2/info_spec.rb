require 'spec_helper'

describe(RCAP::CAP_1_2::Info) do
  before(:each) do
    @info_builder = lambda do |info|
      info.categories << RCAP::CAP_1_2::Info::CATEGORY_GEO
      info.categories << RCAP::CAP_1_2::Info::CATEGORY_FIRE
      info.event = 'Event Description'
      info.response_types << RCAP::CAP_1_2::Info::RESPONSE_TYPE_MONITOR
      info.response_types << RCAP::CAP_1_2::Info::RESPONSE_TYPE_ASSESS
      info.urgency = RCAP::CAP_1_2::Info::URGENCY_IMMEDIATE
      info.severity = RCAP::CAP_1_2::Info::SEVERITY_EXTREME
      info.certainty = RCAP::CAP_1_2::Info::CERTAINTY_OBSERVED
      info.audience = 'Audience'
      info.effective = DateTime.now
      info.onset = DateTime.now + 1
      info.expires = DateTime.now + 2
      info.sender_name = 'Sender Name'
      info.headline = 'Headline'
      info.description = 'Description'
      info.instruction = 'Instruction'
      info.web = 'http://website'
      info.contact = 'contact@address'
      [%w[name1 value1], %w[name2 value2]].each do |name, value|
        info.add_event_code do |event_code|
          event_code.name = name
          event_code.value = value
        end
      end

      info.add_resource do |resource|
        resource.resource_desc = 'Resource'
        resource.mime_type = 'mime/type'
      end

      [%w[name1 value1], %w[name2 value2]].each do |name, value|
        info.add_parameter do |parameter|
          parameter.name = name
          parameter.value = value
        end
      end

      %w[Area1 Area2].each do |area_desc|
        info.add_area do |area|
          area.area_desc = area_desc
        end
      end
    end
  end

  context('on initialisation') do
    before(:each) do
      @info = RCAP::CAP_1_2::Info.new
    end

    it('should have a default language of en-US') do
      @info.language.should == 'en-US'
    end

    it('should have no categories') do
      @info.categories.should(be_empty)
    end

    it('should have no event') do
      @info.event.should(be_nil)
    end

    it('should have no response types') do
      @info.response_types.should(be_empty)
    end

    it('should have no urgency') do
      @info.urgency.should(be_nil)
    end

    it('should have no severity') do
      @info.severity.should(be_nil)
    end

    it('should have no certainty') do
      @info.certainty.should(be_nil)
    end

    it('should have no audience') do
      @info.audience.should(be_nil)
    end

    it('should have no event_codes') do
      @info.event_codes.should(be_empty)
    end

    it('should have no effective datetime') do
      @info.effective.should(be_nil)
    end

    it('should have no onset datetime') do
      @info.onset.should(be_nil)
    end

    it('should have no expires datetime') do
      @info.expires.should(be_nil)
    end

    it('should have no sender name ') do
      @info.sender_name.should(be_nil)
    end

    it('should have no headline') do
      @info.headline.should(be_nil)
    end

    it('should have no description') do
      @info.description.should(be_nil)
    end

    it('should have no instruction') do
      @info.instruction.should(be_nil)
    end

    it('should have no web') do
      @info.web.should(be_nil)
    end

    it('should have no contact') do
      @info.contact.should(be_nil)
    end

    it('should have no parameters') do
      @info.parameters.should(be_empty)
    end

    shared_examples_for('it can parse into a CAP 1.2 Info object') do
      it('should parse categories correctly') do
        @info.categories.should_not(be_empty)
        @info.categories.should == @original_info.categories
      end

      it('should parse event correctly') do
        @info.event.should_not(be_nil)
        @info.event.should == @original_info.event
      end

      it('should parse response_types correctly') do
        @info.response_types.should_not(be_nil)
        @info.response_types.should == @original_info.response_types
      end

      it('should parse urgency correctly') do
        @info.urgency.should_not(be_nil)
        @info.urgency.should == @original_info.urgency
      end

      it('should parse severity correctly') do
        @info.severity.should_not(be_nil)
        @info.severity.should == @original_info.severity
      end

      it('should parse certainty correctly') do
        @info.certainty.should_not(be_nil)
        @info.certainty.should == @original_info.certainty
      end

      it('should parse audience correctly') do
        @info.audience.should_not(be_nil)
        @info.audience.should == @original_info.audience
      end

      it('should parse effective correctly') do
        @info.effective.should_not(be_nil)
        @info.effective.should(be_within(Rational(1, 86_400)).of(@original_info.effective))
      end

      it('should parse onset correctly') do
        @info.onset.should_not(be_nil)
        @info.onset.should(be_within(Rational(1, 86_400)).of(@original_info.onset))
      end

      it('should parse expires correctly') do
        @info.expires.should_not(be_nil)
        @info.expires.should(be_within(Rational(1, 86_400)).of(@original_info.expires))
      end

      it('should parse sender_name correctly') do
        @info.sender_name.should_not(be_nil)
        @info.sender_name.should == @original_info.sender_name
      end

      it('should parse headline correctly') do
        @info.headline.should_not(be_nil)
        @info.headline.should == @original_info.headline
      end

      it('should parse description correctly') do
        @info.description.should_not(be_nil)
        @info.description.should == @original_info.description
      end

      it('should parse instruction correctly') do
        @info.instruction.should_not(be_nil)
        @info.instruction.should == @original_info.instruction
      end

      it('should parse web correctly') do
        @info.web.should_not(be_nil)
        @info.web.should == @original_info.web
      end

      it('should parse contact correctly') do
        @info.contact.should_not(be_nil)
        @info.contact.should == @original_info.contact
      end

      it('should parse event_codes correctly') do
        @info.event_codes.should_not(be_nil)
        @info.event_codes.should == @original_info.event_codes
      end

      it('should parse parameters correctly') do
        @info.parameters.should_not(be_nil)
        @info.parameters.should == @original_info.parameters
      end

      it('should parse resources correctly') do
        @info.resources.should_not(be_nil)
        comparison_attributes = lambda do |resource|
          [
            resource.resource_desc,
            resource.mime_type,
            resource.uri
          ]
        end
        @info.resources.map(&comparison_attributes).should == @original_info.resources.map(&comparison_attributes)
      end

      it('should parse areas correctly') do
        @info.areas.should_not(be_nil)
        @info.areas.should == @original_info.areas
      end
    end

    context('from XML') do
      before(:each) do
        @original_info = RCAP::CAP_1_2::Info.new(&@info_builder)
        @alert = RCAP::CAP_1_2::Alert.new
        @alert.add_info(&@info_builder)
        @xml_string = @alert.to_xml
        @xml_document = REXML::Document.new(@xml_string)
        @info = RCAP::CAP_1_2::Info.from_xml_element(RCAP.xpath_first(@xml_document.root, RCAP::CAP_1_2::Info::XPATH, RCAP::CAP_1_2::Alert::XMLNS))
      end

      it_should_behave_like('it can parse into a CAP 1.2 Info object')
    end

    context('from a hash') do
      before(:each) do
        @original_info = RCAP::CAP_1_2::Info.new(&@info_builder)
        @info = RCAP::CAP_1_2::Info.from_h(@original_info.to_h)
      end
      it_should_behave_like('it can parse into a CAP 1.2 Info object')
    end

    context('from yaml_data') do
      before(:each) do
        @original_info = RCAP::CAP_1_2::Info.new(&@info_builder)
        @info = RCAP::CAP_1_2::Info.from_yaml_data(YAML.load(@original_info.to_yaml))
      end

      it_should_behave_like('it can parse into a CAP 1.2 Info object')
    end
  end

  context('is not valid if it') do
    before(:each) do
      @info = RCAP::CAP_1_2::Info.new do |info|
        info.event = 'Info Event'
        info.categories << RCAP::CAP_1_2::Info::CATEGORY_GEO
        info.urgency    = RCAP::CAP_1_2::Info::URGENCY_IMMEDIATE
        info.severity   = RCAP::CAP_1_2::Info::SEVERITY_EXTREME
        info.certainty  = RCAP::CAP_1_2::Info::CERTAINTY_OBSERVED
      end

      @info.valid?
      @info.should(be_valid)
    end

    it('does not have an event') do
      @info.event = nil
      @info.should_not(be_valid)
    end

    it('does not have categories') do
      @info.categories.clear
      @info.should_not(be_valid)
    end

    it('does not have an urgency') do
      @info.urgency = nil
      @info.should_not(be_valid)
    end

    it('does not have an severity') do
      @info.severity = nil
      @info.should_not(be_valid)
    end

    it('does not have an certainty') do
      @info.certainty = nil
      @info.should_not(be_valid)
    end
  end

  describe('when exported') do
    context('to hash') do
      before(:each) do
        @info = RCAP::CAP_1_2::Info.new(&@info_builder)
        @info_hash = @info.to_h
      end

      it('should export the language correctly') do
        @info_hash[RCAP::CAP_1_2::Info::LANGUAGE_KEY].should == @info.language
      end

      it('should export the categories') do
        @info_hash[RCAP::CAP_1_2::Info::CATEGORIES_KEY].should == @info.categories
      end

      it('should export the event') do
        @info_hash[RCAP::CAP_1_2::Info::EVENT_KEY].should == @info.event
      end

      it('should export the response types') do
        @info_hash[RCAP::CAP_1_2::Info::RESPONSE_TYPES_KEY].should == @info.response_types
      end

      it('should export the urgency') do
        @info_hash[RCAP::CAP_1_2::Info:: URGENCY_KEY].should == @info.urgency
      end

      it('should export the severity') do
        @info_hash[RCAP::CAP_1_2::Info:: SEVERITY_KEY].should == @info.severity
      end

      it('should export the certainty') do
        @info_hash[RCAP::CAP_1_2::Info:: CERTAINTY_KEY].should == @info.certainty
      end

      it('should export the audience') do
        @info_hash[RCAP::CAP_1_2::Info:: AUDIENCE_KEY].should == @info.audience
      end

      it('should export the effective date') do
        @info_hash[RCAP::CAP_1_2::Info::EFFECTIVE_KEY].should == @info.effective.to_s_for_cap
      end

      it('should export the onset date') do
        @info_hash[RCAP::CAP_1_2::Info::ONSET_KEY].should == @info.onset.to_s_for_cap
      end

      it('should export the expires date') do
        @info_hash[RCAP::CAP_1_2::Info::EXPIRES_KEY].should == @info.expires.to_s_for_cap
      end

      it('should export the sender name') do
        @info_hash[RCAP::CAP_1_2::Info::SENDER_NAME_KEY].should == @info.sender_name
      end

      it('should export the headline') do
        @info_hash[RCAP::CAP_1_2::Info::HEADLINE_KEY].should == @info.headline
      end

      it('should export the description') do
        @info_hash[RCAP::CAP_1_2::Info::DESCRIPTION_KEY].should == @info.description
      end

      it('should export the instruction') do
        @info_hash[RCAP::CAP_1_2::Info::INSTRUCTION_KEY].should == @info.instruction
      end

      it('should export the web address ') do
        @info_hash[RCAP::CAP_1_2::Info::WEB_KEY].should == @info.web
      end

      it('should export the contact') do
        @info_hash[RCAP::CAP_1_2::Info::CONTACT_KEY].should == @info.contact
      end

      it('should export the event codes') do
        @info_hash[RCAP::CAP_1_2::Info::EVENT_CODES_KEY].should == @info.event_codes.map { |event_code| event_code.to_h }
      end

      it('should export the parameters ') do
        @info_hash[RCAP::CAP_1_2::Info::PARAMETERS_KEY].should == @info.parameters.map { |parameter| parameter.to_h }
      end

      it('should export the resources ') do
        @info_hash[RCAP::CAP_1_2::Info::RESOURCES_KEY].should == @info.resources.map { |resource| resource.to_h }
      end

      it('should export the areas') do
        @info_hash[RCAP::CAP_1_2::Info::AREAS_KEY].should == @info.areas.map { |area| area.to_h }
      end
    end
  end

  describe('instance methods') do
    before(:each) do
      @info = RCAP::CAP_1_2::Info.new
    end

    describe('#add_event_code') do
      before(:each) do
        @event_code = @info.add_event_code do |event_code|
          event_code.name = 'Event Code'
          event_code.value = '1234'
        end
      end

      it('should return a 1.2 EventCode') do
        @event_code.class.should == RCAP::CAP_1_2::EventCode
        @event_code.name.should == 'Event Code'
        @event_code.value.should == '1234'
      end

      it('should add an EventCode to the event_codes attribute') do
        @info.event_codes.size.should == 1
      end
    end

    describe('#add_parameter') do
      before(:each) do
        @parameter = @info.add_parameter do |parameter|
          parameter.name = 'Parameter'
          parameter.value = '1234'
        end
      end

      it('should return a 1.2 Parameter') do
        @parameter.class.should == RCAP::CAP_1_2::Parameter
        @parameter.name.should == 'Parameter'
        @parameter.value.should == '1234'
      end

      it('should add a Parameter to the parameters attribute') do
        @info.parameters.size.should == 1
      end
    end

    describe('#add_resource') do
      before(:each) do
        @resource = @info.add_resource do |resource|
          resource.resource_desc = 'Resource'
        end
      end

      it('should return a 1.2 Resource') do
        @resource.class.should == RCAP::CAP_1_2::Resource
        @resource.resource_desc.should == 'Resource'
      end

      it('should add a Resource to the resources attribute') do
        @info.resources.size.should == 1
      end
    end

    describe('#add_area') do
      before(:each) do
        @area = @info.add_area do |area|
          area.area_desc = 'Area'
        end
      end

      it('should return a 1.2 area') do
        @area.class.should == RCAP::CAP_1_2::Area
        @area.area_desc.should == 'Area'
      end

      it('should add a Area to the areas attribute') do
        @info.areas.size.should == 1
      end
    end
  end
end
