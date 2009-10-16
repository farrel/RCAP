require 'spec/spec_helper'

class ObjectWithValidatesCollection
  include Validation
  attr_accessor( :collection )
  validates_collection_of( :collection )
  def initialize
    @collection = []
  end
end

class DependencyObject
  include Validation
  attr_accessor( :dependent_value, :contingent_value )
  validates_dependency_of( :dependent_value, :on => :contingent_value )
end

class DependencyWithObject
  include Validation
  attr_accessor( :dependent_value, :contingent_value )
  validates_dependency_of( :dependent_value, :on => :contingent_value, :with_value => true )
end

describe( Validation::ClassMethods ) do
  describe( 'validates_collection_of' ) do
    before( :each ) do
      @object_with_collection = ObjectWithValidatesCollection.new
    end

    it( 'should be valid if all the members are valid' ) do
      @object_with_collection.collection = Array.new(3){ CAP::Point.new( :lattitude => 0, :longitude => 0 )}
      @object_with_collection.should( be_valid )
    end

    it( 'should not be valid some of the members are invalid' ) do
      @object_with_collection.collection = Array.new( 2 ){ CAP::Point.new( :lattitude => 0, :longitude => 0 )} + [ CAP::Point.new( :lattitude => "not a number", :longitude => 0)]
      @object_with_collection.should_not( be_valid )
    end
  end

  describe( 'validates_dependency_of' ) do
    context( 'without :with_value' ) do
      before( :each ) do
        @object = DependencyObject.new
        @object.dependent_value = true
        @object.contingent_value = true
        @object.should( be_valid )
      end

      it( 'should not be valid if the contigent value is nil' ) do
        @object.contingent_value = nil
        @object.should_not( be_valid )
      end
      it( 'should be valid if the dependent value is nil' ) do
        @object.dependent_value = nil
        @object.should( be_valid )
      end
      it( 'should be valid if both are nil' ) do
        @object.dependent_value = nil
        @object.contingent_value = nil
        @object.should( be_valid )
      end
    end

    context( 'with :with_value' ) do
      before( :each ) do
        @object = DependencyWithObject.new
        @object.dependent_value = true
        @object.contingent_value = true
        @object.should( be_valid )
      end

      it( 'should not be valid if the contigent value is nil' ) do
        @object.contingent_value = nil
        @object.should_not( be_valid )
      end

      it( 'should not be valid if the contingent value is not the required value' ) do
        @object.contingent_value = 0
        @object.should_not( be_valid )
      end

      it( 'should be valid if the dependent value is nil' ) do
        @object.dependent_value = nil
        @object.should( be_valid )
      end

      it( 'should be valid if both are nil' ) do
        @object.dependent_value = nil
        @object.contingent_value = nil
        @object.should( be_valid )
      end
    end
  end
end
