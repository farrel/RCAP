module Validation
  module ClassMethods

    CAP_NUMBER_REGEX  = Regexp.new( '^-{0,1}\d*\.{0,1}\d+$' )
    CAP_INTEGER_REGEX = Regexp.new( '\-{0,1}A[+-]?\d+\Z' )

    def validates_inclusion_of( *attributes )
      options = {
        :message => 'is not in the required range'
      }.merge!( attributes.extract_options! )

      validates_each( *attributes ) do |object, attribute, value|
        next if ( value.nil? && options[ :allow_nil ])
        unless options[ :in ].include?( value )
          object.errors[ attribute ] << options[ :message ]
        end
      end
    end

    def validates_inclusion_of_members_of( *attributes )
      options = {
        :message => 'contains members that are not valid'
      }.merge!( attributes.extract_options! )

      validates_each( *attributes ) do |object, attribute, collection|
        next if ( collection.nil? && options[ :allow_nil ]) || ( collection.empty? && options[ :allow_empty ])
        unless collection.all?{ |member| options[ :in ].include?( member )}
          object.errors[ attribute ] << options[ :message ]
        end
      end
    end

    def validates_length_of_members_of( *attributes )
      options = {
        :message => 'contains members with incorrect length'
      }.merge!( attributes.extract_options! )

      validates_each( *attributes ) do |object, attribute, collection|
        next if ( collection.nil? && options[ :allow_nil ]) || ( collection.empty? && options[ :allow_empty ])
        unless options[ :minimum ] && collection.length >= options[ :minimum ]
          object.errors[ attribute ] << options[ :message ]
        end
      end
    end

    def validates_validity_of( *attributes )
      options = {
        :message => 'is not valid'
      }.merge!( attributes.extract_options! )

      validates_each( *attributes ) do |object, attribute, value|
        next if ( value.nil? && options[ :allow_nil ])
        unless value && value.valid?
          object.errors[ attribute ] << options[ :message ]
        end
      end
    end

    def validates_collection_of( *attributes )
      options = {
        :message => 'contains an invalid element'
      }.merge!( attributes.extract_options! )

      validates_each( *attributes ) do |object, attribute, collection|
        next if ( collection.nil? && options[ :allow_nil ]) || ( collection.empty? && options[ :allow_empty ])
        unless collection.all?{ |element| element.valid? }
          object.errors[ attribute ] << options[ :message ]
        end
      end
    end

    def validates_dependency_of( *attributes )
      options = {
        :message => 'is dependent on :attribute being defined'
      }.merge!( attributes.extract_options! )

      validates_each( *attributes ) do |object, attribute, value|
        next if value.blank?
        contingent_on_attribute = object.send( options[ :on ])
        contingent_on_attribute_value = options[ :with_value ]

        if contingent_on_attribute.nil? || !contingent_on_attribute_value.nil? && contingent_on_attribute_value != contingent_on_attribute
          object.errors[ attribute ] << options[ :message ].gsub( /:attribute/, options[ :on ].to_s )
        end
      end
    end

    def validates_conditional_presence_of( *attributes )
      options = {
        :message => 'is not defined but is required by :contingent_attribute'
      }.merge!( attributes.extract_options! )

      validates_each( *attributes ) do |object, attribute, value|
        contingent_attribute_value = object.send( options[ :when ] )
        required_contingent_attribute_value = options[ :is ]

        next if contingent_attribute_value.nil? || contingent_attribute_value != required_contingent_attribute_value && !options[ :is ].blank?
        if value.blank?
          object.errors[ attribute ] << options[ :message ].gsub( /:contingent_attribute/, options[ :whenn ].to_s )
        end
      end
    end


    def validates_numericality_of( *attributes )
      options = {
        :message => 'is not a number or does not meet a conditional requirement',
      }.merge!(attributes.extract_options!)

      re = options[:only_integer] ? CAP_INTEGER_REGEX : CAP_NUMBER_REGEX

      validates_each( *attributes ) do |object, attribute, value|
        next if (value.nil? && options[ :allow_nil ])
        unless ( value.to_s =~ re ) &&
          ( options[ :greater_than ].nil? || value && value > options[ :greater_than ]) &&
          ( options[ :greater_than_or_equal ].nil? || value && value >= options[ :greater_than_or_equal])
          object.errors[ attribute ] << options[ :message ]
        end
      end
    end


    def validates_responsiveness_of( *attributes )
      options = {
        :message => 'does not respond to the given method'
      }.merge!( attributes.extract_options! )

      validates_each( *attributes ) do |object, attribute, value|
        next if ( collection.nil? && options[ :allow_nil ])
        unless options[ :to ].all?{ |method_name| object.respond_to?( method_name )}
          object.errors[ attribute ] << options [ :message ]
        end
      end
    end

    def validates_equality_of_first_and_last( *attributes )
      options = {
        :message => 'does not have equal first and last elements'
      }.merge!( attributes.extract_options! )

      validates_each( *attributes ) do |object, attribute, collection|
        next if ( collection.nil? && options[ :allow_nil ])
        unless collection.first == collection.last
          object.errors[ attribute ] << options[ :message ]
        end
      end
    end
  end
end
