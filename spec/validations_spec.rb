require 'spec_helper'

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
  validates_dependency_of( :dependent_value, :on => :contingent_value, :with_value => 1 )
end

class ConditionalPresenceObject
  include Validation
  attr_accessor( :dependent_value, :contingent_value )
  validates_conditional_presence_of( :dependent_value, when: :contingent_value )
end

class ConditionalPresenceIsObject
  include Validation
  attr_accessor( :dependent_value, :contingent_value )
  validates_conditional_presence_of( :dependent_value, when: :contingent_value, is: 1 )
end

class NumericalityObject
  include Validation
  attr_accessor( :gt, :gte )

  validates_numericality_of( :gt, greater_than: 0 )
  validates_numericality_of( :gte, greater_than_or_equal: 0 )
end

describe( Validation::ClassMethods ) do
  describe( 'validates_collection_of' ) do
    before( :each ) do
      @object_with_collection = ObjectWithValidatesCollection.new
    end

    it( 'should be valid if all the members are valid' ) do
      @object_with_collection.collection = Array.new(3) do
        RCAP::CAP_1_1::Point.new do |point|
          point.lattitude = 0
          point.longitude = 0 
        end
      end
      @object_with_collection.should( be_valid )
    end

    it( 'should not be valid some of the members are invalid' ) do
      @object_with_collection.collection = Array.new( 2 ) do
        RCAP::CAP_1_1::Point.new do |point|
          point.lattitude = 0
          point.longitude = 0 
        end
      end

      @object_with_collection.collection << RCAP::CAP_1_1::Point.new do |point|
        point.lattitude = "not a number"
        point.longitude = 0
      end

      @object_with_collection.should_not( be_valid )
    end
  end

  describe( 'validates_dependency_of' ) do
    context( 'without :with_value' ) do
      before( :each ) do
        @object = DependencyObject.new
        @object.dependent_value = 1
        @object.contingent_value = 1
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
        @object.dependent_value = 1
        @object.contingent_value = 1
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

  describe( 'validates_conditional_presence_of' ) do
    context( 'without :is' ) do
      before( :each ) do
        @object = ConditionalPresenceObject.new
        @object.dependent_value = 1
        @object.contingent_value = 1
        @object.should( be_valid )
      end

      it( 'should not be valid if dependent_value is nil' ) do
        @object.dependent_value = nil
        @object.should_not( be_valid )
      end

      it( 'should be valid if contingent_value is nil' ) do
        @object.contingent_value = nil
        @object.should( be_valid )
      end

      it( 'should be valid if both dependent_value and contingent_value is nil' ) do
        @object.dependent_value = nil
        @object.contingent_value = nil
        @object.should( be_valid )
      end

    end

    context( 'with :is' ) do
      before( :each ) do
        @object = ConditionalPresenceIsObject.new
        @object.dependent_value = 1
        @object.contingent_value = 1
        @object.should( be_valid )
      end

      it( 'should not be valid if dependent_value is nil' ) do
        @object.dependent_value = nil
        @object.should_not( be_valid )
      end

      it( 'should be valid if contingent_value is nil' ) do
        @object.contingent_value = nil
        @object.should( be_valid )
      end

      it( 'should be valid if dependent_value is nil and contingent_value is not required value' ) do
        @object.dependent_value = nil
        @object.contingent_value = 2
        @object.should( be_valid )
      end

      it( 'should be valid if both dependent_value and contingent_value is nil' ) do
        @object.dependent_value = nil
        @object.contingent_value = nil
        @object.should( be_valid )
      end
    end
  end

  describe( 'validates_numericality_of' ) do
    before( :each ) do
      @object = NumericalityObject.new
      @object.gt = 1
      @object.gte = 0
      @object.should( be_valid )
    end

    it( 'should not be valid with a non-numerical value' ) do
      @object.gt = 'one'
      @object.should_not( be_valid )
    end

    it( 'should not be valid if set :greater_than is false' ) do
      @object.gt = 0
      @object.should_not( be_valid )
    end

    it( 'should not be valid if set :greater_than_or_equal is false' ) do
      @object.gte = -1
      @object.should_not( be_valid )
    end
  end
end
