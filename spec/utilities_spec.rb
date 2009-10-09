require 'spec/spec_helper'

describe( Array ) do
  describe( 'to_s' ) do
    context( 'with an element containing white space' ) do
      before( :all ) do
        @list = [ 'one', 'white space', 'three' ]
      end

      it( 'should format the list correctly' ) do
        @list.to_s.should == 'one "white space" three'
      end
    end

    context( 'without an element containing white space' ) do
      before( :all ) do
        @list = [ 'one', 'two', 'three' ]
      end
      it( 'should format the list correctly' ) do
        @list.to_s.should == 'one two three'
      end
    end
  end
end

describe( String ) do
  describe( 'for_cap_list' ) do
    context( 'with white space' ) do
      before( :all ) do
        @string = 'white space'
      end

      it( 'should format the string correctly' ) do
        @string.for_cap_list.should == '"white space"'
      end
    end

    context( 'without white space' ) do
      before( :all ) do
        @string= 'one'
      end
      it( 'should format the string correctly' ) do
        @string.for_cap_list.should == 'one'
      end
    end
  end
end
