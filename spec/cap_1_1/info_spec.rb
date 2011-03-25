require 'spec_helper'

describe( RCAP::CAP_1_1::Info ) do
  context( 'on initialisation' ) do
    before( :each ) do
      @info = RCAP::CAP_1_1::Info.new
    end

    it( 'should have a default language of en-US' ) { @info.language.should == 'en-US' }
    it( 'should have no categories' )               { @info.categories.should( be_empty )}
    it( 'should have no event' )                    { @info.event.should( be_nil )}
    it( 'should have no response types' )           { @info.response_types.should( be_empty )}
    it( 'should have no urgency' )                  { @info.urgency.should( be_nil )}
    it( 'should have no severity' )                 { @info.severity.should( be_nil )}
    it( 'should have no certainty' )                { @info.certainty.should( be_nil )}
    it( 'should have no audience' )                 { @info.audience.should( be_nil )}
    it( 'should have no event_codes' )              { @info.event_codes.should( be_empty )}
    it( 'should have no effective datetime' )       { @info.effective.should( be_nil )}
    it( 'should have no onset datetime' )           { @info.onset.should( be_nil )}
    it( 'should have no expires datetime' )         { @info.expires.should( be_nil )}
    it( 'should have no sender name ' )             { @info.sender_name.should( be_nil )}
    it( 'should have no headline' )                 { @info.headline.should( be_nil )}
    it( 'should have no description' )              { @info.description.should( be_nil )}
    it( 'should have no instruction' )              { @info.instruction.should( be_nil )}
    it( 'should have no web' )                      { @info.web.should( be_nil )}
    it( 'should have no contact' )                  { @info.contact.should( be_nil )}
    it( 'should have no parameters' )               { @info.parameters.should( be_empty )}

    shared_examples_for( 'it can parse into a CAP 1.1 Info object' ) do
      it( 'should parse categories correctly' ){     @info .categories.should     ==    @original_info.categories }
      it( 'should parse event correctly' ){          @info .event.should          ==    @original_info.event }
      it( 'should parse response_types correctly' ){ @info .response_types.should ==    @original_info.response_types }
      it( 'should parse urgency correctly' ){        @info .urgency.should        ==    @original_info.urgency }
      it( 'should parse severity correctly' ){       @info .severity.should       ==    @original_info.severity }
      it( 'should parse certainty correctly' ){      @info .certainty.should      ==    @original_info.certainty }
      it( 'should parse audience correctly' ){       @info .audience.should       ==    @original_info.audience }
      it( 'should parse effective correctly' ){      @info .effective.should( be_within(Rational( 1, 86400 )).of( @original_info.effective ))}
      it( 'should parse onset correctly' ){          @info .onset.should( be_within( Rational( 1, 86400 )).of( @original_info.onset ))}
      it( 'should parse expires correctly' ){        @info .expires.should( be_within( Rational( 1, 86400 )).of( @original_info.expires ))}
      it( 'should parse sender_name correctly' ){    @info .sender_name.should    ==    @original_info.sender_name }
      it( 'should parse headline correctly' ){       @info .headline.should       ==    @original_info.headline }
      it( 'should parse description correctly' ){    @info .description.should    ==    @original_info.description }
      it( 'should parse instruction correctly' ){    @info .instruction.should    ==    @original_info.instruction }
      it( 'should parse web correctly' ){            @info .web.should            ==    @original_info.web }
      it( 'should parse contact correctly' ){        @info .contact.should        ==    @original_info.contact }
      it( 'should parse event_codes correctly' ){    @info .event_codes.should    ==    @original_info.event_codes }
      it( 'should parse parameters correctly' ){     @info .parameters.should     ==    @original_info.parameters }
      it( 'should parse resources correctly' ){      @info .resources.should      ==    @original_info.resources }
      it( 'should parse areas correctly' ){          @info .areas.should          ==    @original_info.areas }
    end

    context( 'from XML' ) do
      before( :each ) do
        @original_info = RCAP::CAP_1_1::Info.new( :categories     => [ RCAP::CAP_1_1::Info::CATEGORY_GEO, RCAP::CAP_1_1::Info::CATEGORY_FIRE ],
                                        :event          => 'Event Description',
                                        :response_types => [ RCAP::CAP_1_1::Info::RESPONSE_TYPE_MONITOR, RCAP::CAP_1_1::Info::RESPONSE_TYPE_ASSESS ],
                                        :urgency        => RCAP::CAP_1_1::Info::URGENCY_IMMEDIATE,
                                        :severity       => RCAP::CAP_1_1::Info::SEVERITY_EXTREME,
                                        :certainty      => RCAP::CAP_1_1::Info::CERTAINTY_OBSERVED,
                                        :audience       => 'Audience',
                                        :effective      => DateTime.now,
                                        :onset          => DateTime.now + 1,
                                        :expires        => DateTime.now + 2,
                                        :sender_name    => 'Sender Name',
                                        :headline       => 'Headline',
                                        :description    => 'Description',
                                        :instruction    => 'Instruction',
                                        :web            => 'http://website',
                                        :contact        => 'contact@address',
                                        :event_codes => [ RCAP::CAP_1_1::EventCode.new( :name => 'name1', :value => 'value1' ),
                                                          RCAP::CAP_1_1::EventCode.new( :name => 'name2', :value => 'value2' )],
                                        :parameters => [ RCAP::CAP_1_1::Parameter.new( :name => 'name1', :value => 'value1' ),
                                                         RCAP::CAP_1_1::Parameter.new( :name => 'name2', :value => 'value2' )],
                                        :areas => [ RCAP::CAP_1_1::Area.new( :area_desc => 'Area1' ),
                                          RCAP::CAP_1_1::Area.new( :area_desc => 'Area2' )]
                                      )
        @alert = RCAP::CAP_1_1::Alert.new( :infos => @original_info )
				@xml_string = @alert.to_xml
				@xml_document = REXML::Document.new( @xml_string )
        @info = RCAP::CAP_1_1::Info.from_xml_element( RCAP.xpath_first( @xml_document.root, RCAP::CAP_1_1::Info::XPATH, RCAP::CAP_1_1::Alert::XMLNS ))
      end

      it_should_behave_like( "it can parse into a CAP 1.1 Info object" )
    end

    context( 'from a hash' ) do
      before( :each ) do
        @original_info = RCAP::CAP_1_1::Info.new( :categories     => [ RCAP::CAP_1_1::Info::CATEGORY_GEO, RCAP::CAP_1_1::Info::CATEGORY_FIRE ],
                                        :event          => 'Event Description',
                                        :response_types => [ RCAP::CAP_1_1::Info::RESPONSE_TYPE_MONITOR, RCAP::CAP_1_1::Info::RESPONSE_TYPE_ASSESS ],
                                        :urgency        => RCAP::CAP_1_1::Info::URGENCY_IMMEDIATE,
                                        :severity       => RCAP::CAP_1_1::Info::SEVERITY_EXTREME,
                                        :certainty      => RCAP::CAP_1_1::Info::CERTAINTY_OBSERVED,
                                        :audience       => 'Audience',
                                        :effective      => DateTime.now,
                                        :onset          => DateTime.now + 1,
                                        :expires        => DateTime.now + 2,
                                        :sender_name    => 'Sender Name',
                                        :headline       => 'Headline',
                                        :description    => 'Description',
                                        :instruction    => 'Instruction',
                                        :web            => 'http://website',
                                        :contact        => 'contact@address',
                                        :event_codes => [ RCAP::CAP_1_1::EventCode.new( :name => 'name1', :value => 'value1' ),
                                                          RCAP::CAP_1_1::EventCode.new( :name => 'name2', :value => 'value2' )],
                                        :parameters => [ RCAP::CAP_1_1::Parameter.new( :name => 'name1', :value => 'value1' ),
                                                         RCAP::CAP_1_1::Parameter.new( :name => 'name2', :value => 'value2' )],
                                        :areas => [ RCAP::CAP_1_1::Area.new( :area_desc => 'Area1' ),
                                          RCAP::CAP_1_1::Area.new( :area_desc => 'Area2' )]
                                      )
        @info = RCAP::CAP_1_1::Info.from_h( @original_info.to_h )
      end
      it_should_behave_like( "it can parse into a CAP 1.1 Info object" )
    end
  end

  context( 'is not valid if it' ) do
    before( :each ) do
      @info = RCAP::CAP_1_1::Info.new( :event => 'Info Event',
                            :categories => RCAP::CAP_1_1::Info::CATEGORY_GEO,
                            :urgency => RCAP::CAP_1_1::Info::URGENCY_IMMEDIATE,
                            :severity => RCAP::CAP_1_1::Info::SEVERITY_EXTREME,
                            :certainty => RCAP::CAP_1_1::Info::CERTAINTY_OBSERVED )
      @info.valid?
      puts @info.errors.full_messages
      @info.should( be_valid )
    end
    
    it( 'does not have an event' ) do
      @info.event = nil
      @info.should_not( be_valid )
    end

    it( 'does not have categories' ) do
      @info.categories.clear
      @info.should_not( be_valid )
    end

    it( 'does not have an urgency' ) do
      @info.urgency = nil
      @info.should_not( be_valid )
    end

    it( 'does not have an severity' ) do
      @info.severity = nil
      @info.should_not( be_valid )
    end

    it( 'does not have an certainty' ) do
      @info.certainty = nil
      @info.should_not( be_valid )
    end
  end


  describe( 'when exported' ) do
    context( 'to hash' ) do
      before( :each ) do
        @info = RCAP::CAP_1_1::Info.new( :categories     => [ RCAP::CAP_1_1::Info::CATEGORY_GEO, RCAP::CAP_1_1::Info::CATEGORY_FIRE ],
                                :event          => 'Event Description',
                                :response_types => [ RCAP::CAP_1_1::Info::RESPONSE_TYPE_MONITOR, RCAP::CAP_1_1::Info::RESPONSE_TYPE_ASSESS ],
                                :urgency        => RCAP::CAP_1_1::Info::URGENCY_IMMEDIATE,
                                :severity       => RCAP::CAP_1_1::Info::SEVERITY_EXTREME,
                                :certainty      => RCAP::CAP_1_1::Info::CERTAINTY_OBSERVED,
                                :audience       => 'Audience',
                                :effective      => DateTime.now,
                                :onset          => DateTime.now + 1,
                                :expires        => DateTime.now + 2,
                                :sender_name    => 'Sender Name',
                                :headline       => 'Headline',
                                :description    => 'Description',
                                :instruction    => 'Instruction',
                                :web            => 'http://website',
                                :contact        => 'contact@address',
                                :resources      => [ RCAP::CAP_1_1::Resource.new( :resource_desc => 'Resource Description', :uri => 'http://tempuri.org/resource' )],
                                :event_codes    => [ RCAP::CAP_1_1::EventCode.new( :name => 'name1', :value => 'value1' ),
                                                     RCAP::CAP_1_1::EventCode.new( :name => 'name2', :value => 'value2' )],
                                :parameters     => [ RCAP::CAP_1_1::Parameter.new( :name => 'name1', :value => 'value1' ),
                                                     RCAP::CAP_1_1::Parameter.new( :name => 'name2', :value => 'value2' )],
                                :areas          => [ RCAP::CAP_1_1::Area.new( :area_desc => 'Area1' ),
                                                     RCAP::CAP_1_1::Area.new( :area_desc => 'Area2' )])
        @info_hash = @info.to_h
      end

      it( 'should export the language correctly' ) do
        @info_hash[ RCAP::CAP_1_1::Info::LANGUAGE_KEY ].should == @info.language
      end

      it( 'should export the categories' ) do
        @info_hash[ RCAP::CAP_1_1::Info::CATEGORIES_KEY ].should == @info.categories
      end
      
      it( 'should export the event' ) do
        @info_hash[ RCAP::CAP_1_1::Info::EVENT_KEY ].should == @info.event
      end

      it( 'should export the response types' ) do
        @info_hash[ RCAP::CAP_1_1::Info::RESPONSE_TYPES_KEY ].should == @info.response_types
      end

      it( 'should export the urgency' ) do
        @info_hash[ RCAP::CAP_1_1::Info:: URGENCY_KEY ].should == @info.urgency
      end

      it( 'should export the severity' ) do
        @info_hash[ RCAP::CAP_1_1::Info:: SEVERITY_KEY ].should == @info.severity
      end

      it( 'should export the certainty' ) do
        @info_hash[ RCAP::CAP_1_1::Info:: CERTAINTY_KEY ].should == @info.certainty
      end

      it( 'should export the audience' ) do
        @info_hash[ RCAP::CAP_1_1::Info:: AUDIENCE_KEY ].should == @info.audience
      end

      it( 'should export the effective date' ) do
        @info_hash[ RCAP::CAP_1_1::Info::EFFECTIVE_KEY ].should == @info.effective.to_s_for_cap
      end

      it( 'should export the onset date' ) do
        @info_hash[ RCAP::CAP_1_1::Info::ONSET_KEY ].should == @info.onset.to_s_for_cap
      end

      it( 'should export the expires date' ) do
        @info_hash[ RCAP::CAP_1_1::Info::EXPIRES_KEY ].should == @info.expires.to_s_for_cap
      end

       it( 'should export the sender name' ) do
         @info_hash[ RCAP::CAP_1_1::Info::SENDER_NAME_KEY ].should == @info.sender_name
       end

       it( 'should export the headline' ) do
         @info_hash[ RCAP::CAP_1_1::Info::HEADLINE_KEY ].should == @info.headline
       end

       it( 'should export the description' ) do
         @info_hash[ RCAP::CAP_1_1::Info::DESCRIPTION_KEY ].should == @info.description
       end

       it( 'should export the instruction' ) do
         @info_hash[ RCAP::CAP_1_1::Info::INSTRUCTION_KEY ].should == @info.instruction
       end

       it( 'should export the web address ' ) do
         @info_hash[ RCAP::CAP_1_1::Info::WEB_KEY ].should == @info.web
       end

       it( 'should export the contact' ) do
         @info_hash[ RCAP::CAP_1_1::Info::CONTACT_KEY ].should == @info.contact
       end

       it( 'should export the event codes' ) do
         @info_hash[ RCAP::CAP_1_1::Info::EVENT_CODES_KEY ].should == @info.event_codes.map{ |event_code| event_code.to_h }
       end

       it( 'should export the parameters ' ) do
         @info_hash[ RCAP::CAP_1_1::Info::PARAMETERS_KEY ].should == @info.parameters.map{ |parameter| parameter.to_h }
       end

       it( 'should export the resources ' ) do
         @info_hash[ RCAP::CAP_1_1::Info::RESOURCES_KEY ].should == @info.resources.map{ |resource| resource.to_h }  
       end

       it( 'should export the areas' ) do
         @info_hash[ RCAP::CAP_1_1::Info::AREAS_KEY ].should == @info.areas.map{ |area| area.to_h }      
       end
    end
  end

  describe( 'instance methods' ) do
    before( :each ) do
      @info = RCAP::CAP_1_1::Info.new
    end

    describe( '#add_event_code' ) do
      before( :each ) do
        @event_code = @info.add_event_code( name: 'Event Code', value: '1234' )
      end

      it( 'should return a 1.1 EventCode' ) do
        @event_code.class.should == RCAP::CAP_1_1::EventCode
        @event_code.name.should == 'Event Code'
        @event_code.value.should == '1234'
      end

      it( 'should add an EventCode to the event_codes attribute' ) do
        @info.event_codes.size.should == 1
      end
    end

    describe( '#add_parameter' ) do
      before( :each ) do
        @parameter = @info.add_parameter( name: 'Parameter', value: '1234' )
      end

      it( 'should return a 1.1 Parameter' ) do
        @parameter.class.should == RCAP::CAP_1_1::Parameter
        @parameter.name.should == 'Parameter'
        @parameter.value.should == '1234'
      end

      it( 'should add a Parameter to the parameters attribute' ) do
        @info.parameters.size.should == 1
      end
    end

    describe( '#add_resource' ) do
      before( :each ) do
        @resource = @info.add_resource( resource_desc: 'Resource' )
      end

      it( 'should return a 1.1 Resource' ) do
        @resource.class.should == RCAP::CAP_1_1::Resource
        @resource.resource_desc.should == 'Resource'
      end

      it( 'should add a Resource to the resources attribute' ) do
        @info.resources.size.should == 1
      end
    end

    describe( '#add_area' ) do
      before( :each ) do
        @area = @info.add_area( area_desc: 'Area' )
      end

      it( 'should return a 1.1 area' ) do
        @area.class.should == RCAP::CAP_1_1::Area
        @area.area_desc.should == 'Area'
      end

      it( 'should add a Area to the areas attribute' ) do
        @info.areas.size.should == 1
      end
    end
  end
end
