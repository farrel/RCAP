describe( RCAP::Alert ) do
  describe( 'initialising' ) do

    context( 'a CAP 1.1 alert' ) do
      before( :each ) do
        @original_alert = RCAP::CAP_1_1::Alert.new( :sender => 'Sender',
                                                    :status => RCAP::CAP_1_1::Alert::STATUS_TEST,
                                                    :scope => RCAP::CAP_1_1::Alert::SCOPE_PUBLIC,
                                                    :source => 'Source',
                                                    :restriction => 'No Restriction',
                                                    :addresses => [ 'Address 1', 'Address 2'],
                                                    :code => ['Code1', 'Code2'],
                                                    :note => 'Note',
                                                    :references => [ RCAP::CAP_1_1::Alert.new( :sender => 'Sender1' ).to_reference, 
                                                                     RCAP::CAP_1_1::Alert.new( :sender => 'Sender2' ).to_reference ],
                                                    :incidents => [ 'Incident1', 'Incident2' ],
                                                    :infos => [ RCAP::CAP_1_1::Info.new, RCAP::CAP_1_1::Info.new ])
      end



      shared_examples_for( 'it has parsed a CAP 1.1 alert correctly' ) do
        it( 'should use the correct CAP Version' ){ @alert.class.should       == RCAP::CAP_1_1::Alert }
        it( 'should parse identifier correctly' ) { @alert.identifier.should  == @original_alert.identifier }
        it( 'should parse sender correctly' )     { @alert.sender.should      == @original_alert.sender }
        it( 'should parse sent correctly' )       { @alert.sent.should( be_within( Rational(1, 86400 )).of( @original_alert.sent ))}
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
          @alert = RCAP::Alert.from_xml( @original_alert.to_xml )
        end

        it_should_behave_like( 'it has parsed a CAP 1.1 alert correctly' )
      end

      context( 'from YAML' ) do
        before( :each ) do
          @alert = RCAP::Alert.from_yaml( @original_alert.to_yaml )
        end

        it_should_behave_like( 'it has parsed a CAP 1.1 alert correctly' )
      end

      context( 'from JSON' ) do
        before( :each ) do
          @alert = RCAP::Alert.from_json( @original_alert.to_json )
        end

        it_should_behave_like( 'it has parsed a CAP 1.1 alert correctly' )
      end
    end

    context( 'a CAP 1.2 alert' ) do
      before( :each ) do
        @original_alert = RCAP::CAP_1_2::Alert.new( :sender => 'Sender',
                                                    :status => RCAP::CAP_1_2::Alert::STATUS_TEST,
                                                    :scope => RCAP::CAP_1_2::Alert::SCOPE_PUBLIC,
                                                    :source => 'Source',
                                                    :restriction => 'No Restriction',
                                                    :addresses => [ 'Address 1', 'Address 2'],
                                                    :codes => [ 'Code1', 'Code2'],
                                                    :note => 'Note',
                                                    :references => [ RCAP::CAP_1_2::Alert.new( :sender => 'Sender1' ).to_reference, 
                                                                     RCAP::CAP_1_2::Alert.new( :sender => 'Sender2' ).to_reference ],
                                                    :incidents => [ 'Incident1', 'Incident2' ],
                                                    :infos => [ RCAP::CAP_1_2::Info.new, RCAP::CAP_1_2::Info.new ])
      end



      shared_examples_for( 'it has parsed a CAP 1.2 alert correctly' ) do
        it( 'should use the correct CAP Version' ){ @alert.class.should       == RCAP::CAP_1_2::Alert }
        it( 'should parse identifier correctly' ) { @alert.identifier.should  == @original_alert.identifier }
        it( 'should parse sender correctly' )     { @alert.sender.should      == @original_alert.sender }
        it( 'should parse sent correctly' )       { @alert.sent.should( be_within( Rational(1, 86400 )).of( @original_alert.sent ))}
        it( 'should parse status correctly' )     { @alert.status.should      == @original_alert.status }
        it( 'should parse msg_type correctly' )   { @alert.msg_type.should    == @original_alert.msg_type }
        it( 'should parse source correctly' )     { @alert.source.should      == @original_alert.source }
        it( 'should parse scope correctly' )      { @alert.scope.should       == @original_alert.scope }
        it( 'should parse restriction correctly' ){ @alert.restriction.should == @original_alert.restriction }
        it( 'should parse addresses correctly' )  { @alert.addresses.should   == @original_alert.addresses }
        it( 'should parse codes correctly' )      { @alert.codes.should       == @original_alert.codes }
        it( 'should parse note correctly' )       { @alert.note.should        == @original_alert.note }
        it( 'should parse references correctly' ) { @alert.references.should  == @original_alert.references }
        it( 'should parse incidents correctly' )  { @alert.incidents.should   == @original_alert.incidents }
        it( 'should parse infos correctly' ) do 
          @alert.infos.size.should == @original_alert.infos.size 
          @alert.infos.each{ |info| info.class.should == RCAP::CAP_1_2::Info }
        end
      end

      context( 'from XML' ) do
        before( :each ) do
          @alert = RCAP::Alert.from_xml( @original_alert.to_xml )
        end

        it_should_behave_like( 'it has parsed a CAP 1.2 alert correctly' )
      end

      context( 'from YAML' ) do
        before( :each ) do
          @alert = RCAP::Alert.from_yaml( @original_alert.to_yaml )
        end

        it_should_behave_like( 'it has parsed a CAP 1.2 alert correctly' )
      end

      context( 'from JSON' ) do
        before( :each ) do
          @alert = RCAP::Alert.from_json( @original_alert.to_json )
        end

        it_should_behave_like( 'it has parsed a CAP 1.2 alert correctly' )
      end
    end
  end
end
