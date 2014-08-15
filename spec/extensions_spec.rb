require 'spec_helper'

describe(Array) do
  describe('to_s_for_cap') do
    context('with an element containing white space') do
      before(:all) do
        @list = ['one', 'white space', 'three']
      end

      it('should format the list correctly') do
        @list.to_s_for_cap.should == 'one "white space" three'
      end
    end

    context('without an element containing white space') do
      before(:all) do
        @list = %w(one two three)
      end
      it('should format the list correctly') do
        @list.to_s_for_cap.should == 'one two three'
      end
    end
  end
end

describe(String) do
  describe('for_cap_list') do
    context('with white space') do
      before(:all) do
        @string = 'white space'
      end

      it('should format the string correctly') do
        @string.for_cap_list.should == '"white space"'
      end
    end

    context('without white space') do
      before(:all) do
        @string = 'one'
      end
      it('should format the string correctly') do
        @string.for_cap_list.should == 'one'
      end
    end
  end

  describe('unpack_cap_list') do
    it('shoud unpack strings in quotes correctly') do
      'Item1 "Item 2" Item3'.unpack_cap_list.should == ['Item1', 'Item 2', 'Item3']
    end

    it('should unpack strings correclty') do
      'Item1 Item2 Item3'.unpack_cap_list.should == %w(Item1 Item2 Item3)
    end
  end

  describe('attribute_values_to_hash') do
    it('should reject nil values') do
      RCAP.attribute_values_to_hash(['a', nil]).should == {}
    end

    it('should not reject non-nil and non-empty values') do
      RCAP.attribute_values_to_hash(['a', 1], ['b', [2]]).should == { 'a' => 1, 'b' => [2] }
    end
  end
end
