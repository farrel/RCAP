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
end
