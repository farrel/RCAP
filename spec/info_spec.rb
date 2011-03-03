require 'spec_helper'

describe( RCAP::Info ) do
  context( 'on initialisation' ) do
    before( :each ) do
      @info = RCAP::Info.new
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

    shared_examples_for( 'it can parse into an Info object' ) do
      it( 'should parse categories correctly' ){     @info .categories.should     ==    @original_info.categories }
      it( 'should parse event correctly' ){          @info .event.should          ==    @original_info.event }
      it( 'should parse response_types correctly' ){ @info .response_types.should ==    @original_info.response_types }
      it( 'should parse urgency correctly' ){        @info .urgency.should        ==    @original_info.urgency }
      it( 'should parse severity correctly' ){       @info .severity.should       ==    @original_info.severity }
      it( 'should parse certainty correctly' ){      @info .certainty.should      ==    @original_info.certainty }
      it( 'should parse audience correctly' ){       @info .audience.should       ==    @original_info.audience }
      it( 'should parse effective correctly' ){      @info .effective.should( be_close( @original_info.effective, Rational( 1, 86400 )))}
      it( 'should parse onset correctly' ){          @info .onset.should( be_close(     @original_info.onset, Rational( 1, 86400 )))}
      it( 'should parse expires correctly' ){        @info .expires.should( be_close(   @original_info.expires, Rational( 1, 86400 )))}
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
        @original_info = RCAP::Info.new( :categories     => [ RCAP::Info::CATEGORY_GEO, RCAP::Info::CATEGORY_FIRE ],
                                        :event          => 'Event Description',
                                        :response_types => [ RCAP::Info::RESPONSE_TYPE_MONITOR, RCAP::Info::RESPONSE_TYPE_ASSESS ],
                                        :urgency        => RCAP::Info::URGENCY_IMMEDIATE,
                                        :severity       => RCAP::Info::SEVERITY_EXTREME,
                                        :certainty      => RCAP::Info::CERTAINTY_OBSERVED,
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
                                        :event_codes => [ RCAP::EventCode.new( :name => 'name1', :value => 'value1' ),
                                                          RCAP::EventCode.new( :name => 'name2', :value => 'value2' )],
                                        :parameters => [ RCAP::Parameter.new( :name => 'name1', :value => 'value1' ),
                                                         RCAP::Parameter.new( :name => 'name2', :value => 'value2' )],
                                        :areas => [ RCAP::Area.new( :area_desc => 'Area1' ),
                                          RCAP::Area.new( :area_desc => 'Area2' )]
                                      )
        @alert = RCAP::Alert.new( :infos => @original_info )
				@xml_string = @alert.to_xml
				@xml_document = REXML::Document.new( @xml_string )
        @info = RCAP::Info.from_xml_element( RCAP.xpath_first( @xml_document.root, RCAP::Info::XPATH ))
      end

      it_should_behave_like( "it can parse into an Info object" )
    end

    context( 'from a hash' ) do
      before( :each ) do
        @original_info = RCAP::Info.new( :categories     => [ RCAP::Info::CATEGORY_GEO, RCAP::Info::CATEGORY_FIRE ],
                                        :event          => 'Event Description',
                                        :response_types => [ RCAP::Info::RESPONSE_TYPE_MONITOR, RCAP::Info::RESPONSE_TYPE_ASSESS ],
                                        :urgency        => RCAP::Info::URGENCY_IMMEDIATE,
                                        :severity       => RCAP::Info::SEVERITY_EXTREME,
                                        :certainty      => RCAP::Info::CERTAINTY_OBSERVED,
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
                                        :event_codes => [ RCAP::EventCode.new( :name => 'name1', :value => 'value1' ),
                                                          RCAP::EventCode.new( :name => 'name2', :value => 'value2' )],
                                        :parameters => [ RCAP::Parameter.new( :name => 'name1', :value => 'value1' ),
                                                         RCAP::Parameter.new( :name => 'name2', :value => 'value2' )],
                                        :areas => [ RCAP::Area.new( :area_desc => 'Area1' ),
                                          RCAP::Area.new( :area_desc => 'Area2' )]
                                      )
        @info = RCAP::Info.from_h( @original_info.to_h )
      end
      it_should_behave_like( "it can parse into an Info object" )
    end
  end

  context( 'is not valid if it' ) do
    before( :each ) do
      @info = RCAP::Info.new( :event => 'Info Event',
                            :categories => RCAP::Info::CATEGORY_GEO,
                            :urgency => RCAP::Info::URGENCY_IMMEDIATE,
                            :severity => RCAP::Info::SEVERITY_EXTREME,
                            :certainty => RCAP::Info::CERTAINTY_OBSERVED )
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
        @info = RCAP::Info.new( :categories     => [ RCAP::Info::CATEGORY_GEO, RCAP::Info::CATEGORY_FIRE ],
                                :event          => 'Event Description',
                                :response_types => [ RCAP::Info::RESPONSE_TYPE_MONITOR, RCAP::Info::RESPONSE_TYPE_ASSESS ],
                                :urgency        => RCAP::Info::URGENCY_IMMEDIATE,
                                :severity       => RCAP::Info::SEVERITY_EXTREME,
                                :certainty      => RCAP::Info::CERTAINTY_OBSERVED,
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
                                :resources      => [ RCAP::Resource.new( :resource_desc => 'Resource Description', :uri => 'http://tempuri.org/resource' )],
                                :event_codes    => [ RCAP::EventCode.new( :name => 'name1', :value => 'value1' ),
                                                     RCAP::EventCode.new( :name => 'name2', :value => 'value2' )],
                                :parameters     => [ RCAP::Parameter.new( :name => 'name1', :value => 'value1' ),
                                                     RCAP::Parameter.new( :name => 'name2', :value => 'value2' )],
                                :areas          => [ RCAP::Area.new( :area_desc => 'Area1' ),
                                                     RCAP::Area.new( :area_desc => 'Area2' )])
        @info_hash = @info.to_h
      end

      it( 'should export the language correctly' ) do
        @info_hash[ 'language' ].should == @info.language
      end

      it( 'should export the categories' ) do
        @info_hash[ 'categories' ].should == @info.categories
      end
      
      it( 'should export the event' ) do
        @info_hash[ 'event' ].should == @info.event
      end

      it( 'should export the response types' ) do
        @info_hash[ 'response_types' ].should == @info.response_types
      end

      it( 'should export the urgency' ) do
        @info_hash[  'urgency' ].should == @info.urgency
      end

      it( 'should export the severity' ) do
        @info_hash[  'severity' ].should == @info.severity
      end

      it( 'should export the certainty' ) do
        @info_hash[  'certainty' ].should == @info.certainty
      end

      it( 'should export the audience' ) do
        @info_hash[  'audience' ].should == @info.audience
      end

      it( 'should export the effective date' ) do
        @info_hash[ 'effective' ].should == @info.effective
      end

      it( 'should export the onset date' ) do
        @info_hash[ 'onset' ].should == @info.onset
      end

      it( 'should export the expires date' ) do
        @info_hash[ 'expires' ].should == @info.expires
      end

       it( 'should export the sender name' ) do
         @info_hash[ 'sender_name' ].should == @info.sender_name
       end

       it( 'should export the headline' ) do
         @info_hash[ 'headline' ].should == @info.headline
       end

       it( 'should export the description' ) do
         @info_hash[ 'description' ].should == @info.description
       end

       it( 'should export the instruction' ) do
         @info_hash[ 'instruction' ].should == @info.instruction
       end

       it( 'should export the web address ' ) do
         @info_hash[ 'web' ].should == @info.web
       end

       it( 'should export the contact' ) do
         @info_hash[ 'contact' ].should == @info.contact
       end

       it( 'should export the event codes' ) do
         @info_hash[ 'event_codes' ].should == @info.event_codes.map{ |event_code| event_code.to_h }
       end

       it( 'should export the parameters ' ) do
         @info_hash[ 'parameters' ].should == @info.parameters.map{ |parameter| parameter.to_h }
       end

       it( 'should export the resources ' ) do
         @info_hash[ 'resources' ].should == @info.resources.map{ |resource| resource.to_h }  
       end

       it( 'should export the areas' ) do
         @info_hash[ 'areas' ].should == @info.areas.map{ |area| area.to_h }      
       end
    end
  end
end
