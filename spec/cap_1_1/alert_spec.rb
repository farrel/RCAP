require 'spec_helper'

describe( RCAP::CAP_1_1::Alert ) do
  context( 'on initialisation' ) do
    before( :each )  do
      @alert = RCAP::CAP_1_1::Alert.new
    end

    it( 'should have a identifier' ){ @alert.identifier.should_not( be_nil )}
    it( 'should not have a sender' ){ @alert.sender.should( be_nil )}
    it( 'should not have a sent time' ){ @alert.sent.should( be_nil )}
    it( 'should not have a status' ){ @alert.status.should( be_nil )}
    it( 'should not have a scope' ){ @alert.scope.should( be_nil )}
    it( 'should not have a source'){ @alert.source.should( be_nil )}
    it( 'should not have a restriction'){ @alert.restriction.should( be_nil )}
    it( 'should not have any addresses' ){ @alert.addresses.should( be_empty )}
    it( 'should not have any codes' ){ @alert.codes.should( be_empty )}
    it( 'should not have a note' ){ @alert.note.should( be_nil )}
    it( 'should not have any references' ){ @alert.references.should( be_empty )}
    it( 'should not have any incidents' ){ @alert.incidents.should( be_empty )}
    it( 'should not have any infos' ){ @alert.infos.should( be_empty )}

    shared_examples_for( "a successfully parsed CAP 1.1 alert" ) do
      it( 'should parse identifier correctly' ) { @alert.identifier.should  == @original_alert.identifier }
      it( 'should parse sender correctly' )     { @alert.sender.should      == @original_alert.sender }
      it( 'should parse sent correctly' )       { @alert.sent.should( be_within( 1 ).of( @original_alert.sent ))}
      it( 'should parse status correctly' )     { @alert.status.should      == @original_alert.status }
      it( 'should parse msg_type correctly' )   { @alert.msg_type.should    == @original_alert.msg_type }
      it( 'should parse source correctly' )     { @alert.source.should      == @original_alert.source }
      it( 'should parse scope correctly' )      { @alert.scope.should       == @original_alert.scope }
      it( 'should parse restriction correctly' ){ @alert.restriction.should == @original_alert.restriction }
      it( 'should parse addresses correctly' )  { @alert.addresses.should   == @original_alert.addresses }
      it( 'should parse code correctly' )       { @alert.codes.should       == @original_alert.codes }
      it( 'should parse note correctly' )       { @alert.note.should        == @original_alert.note }
      it( 'should parse references correctly' ) { @alert.references.should  == @original_alert.references }
      it( 'should parse incidents correctly' )  { @alert.incidents.should   == @original_alert.incidents }
      it( 'should parse infos correctly' ) do
        @alert.infos.size.should == @original_alert.infos.size
        @alert.infos.each{ |info| info.class.should == RCAP::CAP_1_1::Info }
      end
    end

    context( 'from XML' ) do
      before( :each ) do
        @original_alert = RCAP::CAP_1_1::Alert.new( :sender      => 'Sender',
                                                    :sent        => DateTime.now,
                                                    :status      => RCAP::CAP_1_1::Alert::STATUS_TEST,
                                                    :scope       => RCAP::CAP_1_1::Alert::SCOPE_PUBLIC,
                                                    :source      => 'Source',
                                                    :restriction => 'No Restriction',
                                                    :addresses   => [ 'Address 1', 'Address 2'],
                                                    :codes       => [ 'Code1', 'Code2' ],
                                                    :note        => 'Note',
                                                    :references  => [ RCAP::CAP_1_1::Alert.new( :sender => 'Sender1' ).to_reference, RCAP::CAP_1_1::Alert.new( :sender => 'Sender2' ).to_reference ],
                                                    :incidents   => [ 'Incident1', 'Incident2' ],
                                                    :infos       => [ RCAP::CAP_1_1::Info.new, RCAP::CAP_1_1::Info.new ])
        @xml_string = @original_alert.to_xml
        @xml_document = REXML::Document.new( @xml_string )
        @alert_element = @xml_document.root
        @alert = RCAP::CAP_1_1::Alert.from_xml_element( @alert_element )
      end

      it_should_behave_like( "a successfully parsed CAP 1.1 alert" )

    end

    context( 'from YAML' ) do
      before( :each ) do
        @original_alert = RCAP::CAP_1_1::Alert.new( :sender      => 'Sender',
                                                    :sent        => DateTime.now,
                                                    :status      => RCAP::CAP_1_1::Alert::STATUS_TEST,
                                                    :scope       => RCAP::CAP_1_1::Alert::SCOPE_PUBLIC,
                                                    :source      => 'Source',
                                                    :restriction => 'No Restriction',
                                                    :addresses   => [ 'Address 1', 'Address 2'],
                                                    :codes       => [ 'Code1', 'Code2' ],
                                                    :note        => 'Note',
                                                    :references  => [ RCAP::CAP_1_1::Alert.new( :sender => 'Sender1' ).to_reference, RCAP::CAP_1_1::Alert.new( :sender => 'Sender2' ).to_reference ],
                                                    :incidents   => [ 'Incident1', 'Incident2' ],
                                                    :infos       => [ RCAP::CAP_1_1::Info.new, RCAP::CAP_1_1::Info.new ])
        @yaml_string = @original_alert.to_yaml
        @alert = RCAP::CAP_1_1::Alert.from_yaml( @yaml_string )
      end

      it_should_behave_like( "a successfully parsed CAP 1.1 alert" )
    end

    context( 'from a hash' ) do
      before( :each ) do
        @original_alert = RCAP::CAP_1_1::Alert.new( :sender      => 'Sender',
                                                    :sent        => DateTime.now,
                                                    :status      => RCAP::CAP_1_1::Alert::STATUS_TEST,
                                                    :scope       => RCAP::CAP_1_1::Alert::SCOPE_PUBLIC,
                                                    :source      => 'Source',
                                                    :restriction => 'No Restriction',
                                                    :addresses   => [ 'Address 1', 'Address 2'],
                                                    :codes       => [ 'Code1', 'Code2' ],
                                                    :note        => 'Note',
                                                    :references  => [ RCAP::CAP_1_1::Alert.new( :sender => 'Sender1' ).to_reference, RCAP::CAP_1_1::Alert.new( :sender => 'Sender2' ).to_reference ],
                                                    :incidents   => [ 'Incident1', 'Incident2' ],
                                                    :infos       => [ RCAP::CAP_1_1::Info.new, RCAP::CAP_1_1::Info.new ])
        @alert = RCAP::CAP_1_1::Alert.from_h( @original_alert.to_h )
      end

      it_should_behave_like( "a successfully parsed CAP 1.1 alert" )
    end

    context( 'from JSON' ) do
      before( :each ) do
        @original_alert = RCAP::CAP_1_1::Alert.new( :sender      => 'Sender',
                                                    :sent        => DateTime.now,
                                                    :status      => RCAP::CAP_1_1::Alert::STATUS_TEST,
                                                    :scope       => RCAP::CAP_1_1::Alert::SCOPE_PUBLIC,
                                                    :source      => 'Source',
                                                    :restriction => 'No Restriction',
                                                    :addresses   => [ 'Address 1', 'Address 2'],
                                                    :codes       => [ 'Code1', 'Code2' ],
                                                    :note        => 'Note',
                                                    :references  => [ RCAP::CAP_1_1::Alert.new( :sender => 'Sender1' ).to_reference, RCAP::CAP_1_1::Alert.new( :sender => 'Sender2' ).to_reference ],
                                                    :incidents   => [ 'Incident1', 'Incident2' ],
                                                    :infos       => [ RCAP::CAP_1_1::Info.new, RCAP::CAP_1_1::Info.new ])
        @alert = RCAP::CAP_1_1::Alert.from_json( @original_alert.to_json )
      end

      it_should_behave_like( "a successfully parsed CAP 1.1 alert" )
    end
  end

  describe( 'is not valid if it' ) do
    before( :each ) do
      @alert = RCAP::CAP_1_1::Alert.new( :identifier => 'Identifier',
                                         :sender     => "cap@tempuri.org",
                                         :sent       => DateTime.now,
                                         :status     => RCAP::CAP_1_1::Alert::STATUS_TEST,
                                         :msg_type   => RCAP::CAP_1_1::Alert::MSG_TYPE_ALERT,
                                         :scope      => RCAP::CAP_1_1::Alert::SCOPE_PUBLIC )
      @alert.should( be_valid )
    end

    it( 'does not have a identifier' ) do
      @alert.identifier = nil
      @alert.should_not( be_valid )
    end

    it( 'does not have a sender' ) do
      @alert.sender = nil
      @alert.should_not( be_valid )
    end

    it( 'does not have a sent time (sent)' ) do
      @alert.sent = nil
      @alert.should_not( be_valid )
    end

    it( 'does not have a status' ) do
      @alert.status = nil
      @alert.should_not( be_valid )
    end

    it( 'does not have a message type (msg_type)' ) do
      @alert.msg_type = nil
      @alert.should_not( be_valid )
    end

    it( 'does not have a scope' ) do
      @alert.scope = nil
      @alert.should_not( be_valid )
    end


    it( 'does not have a valid status' ) do
      @alert.status = 'incorrect value'
      @alert.should_not( be_valid )
    end

    it( 'does not have a valid message type msg_type' ) do
      @alert.msg_type = 'incorrect value'
      @alert.should_not( be_valid )
    end

    it( 'does not have a valid scope' ) do
      @alert.scope = 'incorrect value'
      @alert.should_not( be_valid )
    end


    context( 'has an info element and it' ) do
      it( 'is not valid' ) do
        @info = RCAP::CAP_1_1::Info.new( :event => 'Info Event',
                              :categories => RCAP::CAP_1_1::Info::CATEGORY_GEO,
                              :urgency => RCAP::CAP_1_1::Info::URGENCY_IMMEDIATE,
                              :severity => RCAP::CAP_1_1::Info::SEVERITY_EXTREME,
                              :certainty => RCAP::CAP_1_1::Info::CERTAINTY_OBSERVED )
        @info.event = nil
        @alert.infos << @info
        @info.should_not( be_valid )
        @alert.should_not( be_valid )
      end
    end
  end

  describe( 'instance methods' ) do
    before( :each ) do
      @alert = RCAP::CAP_1_1::Alert.new
    end

    describe( '#add_info' ) do
      before( :each ) do
        @info = @alert.add_info( :urgency => 'urgent' )
        @info.urgency.should == 'urgent'
      end

      it( 'should return a CAP 1.1 Info object' ) do
        @info.class.should == RCAP::CAP_1_1::Info
      end

      it( 'should add an Info object to the infos array' ) do
        @alert.infos.size.should == 1
      end
    end
  end
end
