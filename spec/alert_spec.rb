describe( RCAP::Alert ) do
  describe( 'initialising' ) do

    context( 'a CAP 1.0 alert' ) do
      before( :each ) do
        @original_alert = RCAP::CAP_1_0::Alert.new( :sender => 'Sender',
                                                    :sent => DateTime.now,
                                                    :status => RCAP::CAP_1_0::Alert::STATUS_TEST,
                                                    :scope => RCAP::CAP_1_0::Alert::SCOPE_PUBLIC,
                                                    :source => 'Source',
                                                    :restriction => 'No Restriction',
                                                    :addresses => [ 'Address 1', 'Address 2'],
                                                    :code => ['Code1', 'Code2'],
                                                    :note => 'Note',
                                                    :references => [ "1.0,1", "1.0,2" ],
                                                    :incidents => [ 'Incident1', 'Incident2' ],
                                                    :infos => [ RCAP::CAP_1_0::Info.new, RCAP::CAP_1_0::Info.new ])
      end

      shared_examples_for( 'it has parsed a CAP 1.0 alert correctly' ) do
        it( 'should use the correct CAP Version' ){ @alert.class.should       == RCAP::CAP_1_0::Alert }
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
          @alert.infos.each{ |info| info.class.should == RCAP::CAP_1_0::Info }
        end
      end

      context( 'from XML' ) do
        before( :each ) do
          @alert = RCAP::Alert.from_xml( @original_alert.to_xml )
        end

        it_should_behave_like( 'it has parsed a CAP 1.0 alert correctly' )
      end

      context( 'from YAML' ) do
        before( :each ) do
          @alert = RCAP::Alert.from_yaml( @original_alert.to_yaml )
        end

        it_should_behave_like( 'it has parsed a CAP 1.0 alert correctly' )
      end

      context( 'from JSON' ) do
        before( :each ) do
          @alert = RCAP::Alert.from_json( @original_alert.to_json )
        end

        it_should_behave_like( 'it has parsed a CAP 1.0 alert correctly' )
      end
    end

    context( 'a CAP 1.1 alert' ) do
      before( :each ) do
        @original_alert = RCAP::CAP_1_1::Alert.new( :sender => 'Sender',
                                                    :sent => DateTime.now,
                                                    :status => RCAP::CAP_1_1::Alert::STATUS_TEST,
                                                    :scope => RCAP::CAP_1_1::Alert::SCOPE_PUBLIC,
                                                    :source => 'Source',
                                                    :restriction => 'No Restriction',
                                                    :addresses => [ 'Address 1', 'Address 2'],
                                                    :code => ['Code1', 'Code2'],
                                                    :note => 'Note',
                                                    :references => [ "1,1,1", "1,1,2" ],
                                                    :incidents => [ 'Incident1', 'Incident2' ],
                                                    :infos => [ RCAP::CAP_1_1::Info.new, RCAP::CAP_1_1::Info.new ])
      end

      shared_examples_for( 'it has parsed a CAP 1.1 alert correctly' ) do
        it( 'should use the correct CAP Version' ){ @alert.class.should       == RCAP::CAP_1_1::Alert }
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
                                                    :sent => DateTime.now,
                                                    :status => RCAP::CAP_1_2::Alert::STATUS_TEST,
                                                    :scope => RCAP::CAP_1_2::Alert::SCOPE_PUBLIC,
                                                    :source => 'Source',
                                                    :restriction => 'No Restriction',
                                                    :addresses => [ 'Address 1', 'Address 2'],
                                                    :codes => [ 'Code1', 'Code2'],
                                                    :note => 'Note',
                                                    :references => [ "1,1,1", "1,1,2" ],
                                                    :incidents => [ 'Incident1', 'Incident2' ],
                                                    :infos => [ RCAP::CAP_1_2::Info.new, RCAP::CAP_1_2::Info.new ])
      end

      shared_examples_for( 'it has parsed a CAP 1.2 alert correctly' ) do
        it( 'should use the correct CAP Version' ){ @alert.class.should       == RCAP::CAP_1_2::Alert }
        it( 'should parse identifier correctly' ) { @alert.identifier.should  == @original_alert.identifier }
        it( 'should parse sender correctly' )     { @alert.sender.should      == @original_alert.sender }
        it( 'should parse sent correctly' )       { @alert.sent.should( be_within( 1 ).of( @original_alert.sent ))}
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

  describe( 'external file' ) do
    def load_file( file_name ) 
      File.open( File.join( File.dirname( __FILE__ ), 'assets', file_name )){|f| f.read }
    end

    describe( "'invalid.cap'" ) do
      before( :each ) do
        @alert = RCAP::Alert.from_xml( load_file( 'invalid.cap' ))
      end

      it( 'should not be valid' ) do
        @alert.should_not( be_valid )
      end

      it( 'should be invalid because scope is missing' ) do
        @alert.valid?
        @alert.errors.on( :scope ).should_not( be_empty )
      end
    end

    describe( "'earthquake.cap'" ) do
      before( :each ) do
        @alert = RCAP::Alert.from_xml( load_file( 'earthquake.cap' ))
      end

      it( 'should be valid' ) do
        @alert.should( be_valid )
      end

      it( 'should parse the alert correctly' ) do
        @alert.class.should == RCAP::CAP_1_1::Alert
        @alert.status.should == RCAP::CAP_1_1::Alert::STATUS_ACTUAL
        @alert.msg_type.should == RCAP::CAP_1_1::Alert::MSG_TYPE_ALERT
        @alert.scope.should == RCAP::CAP_1_1::Alert::SCOPE_PUBLIC

        @alert.infos.size.should == 2
        info = @alert.infos.first
        info.categories.include?( RCAP::CAP_1_1::Info::CATEGORY_GEO ).should( be_true )

        info.areas.size.should == 1
        area = info.areas.first

        area.circles.size.should == 1
        circle = area.circles.first
        circle.lattitude.should == -16.053
        circle.longitude.should == -173.274
        circle.radius.should == 0
      end
    end

    describe( "'canada.cap'" ) do
      before( :each ) do
        @alert = RCAP::Alert.from_xml( load_file( 'canada.cap' ))
      end

      it( 'should be valid' ) do
        @alert.should( be_valid )
      end

      it( 'should parse the alert correctly' ) do
        @alert.class.should == RCAP::CAP_1_1::Alert
        @alert.status.should == RCAP::CAP_1_1::Alert::STATUS_ACTUAL
        @alert.msg_type.should == RCAP::CAP_1_1::Alert::MSG_TYPE_UPDATE
        @alert.scope.should == RCAP::CAP_1_1::Alert::SCOPE_PUBLIC
        @aliert.identifier.should == "CA-EC-CWTO-2011-138776"

        @alert.infos.size.should == 2
        info = @alert.infos.first
        info.event_codes.first.value = 'storm'
      end
    end
  end
end
