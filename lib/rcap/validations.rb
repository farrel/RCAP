module Validation
  module ClassMethods

		NUMBER_RE  = /^-{0,1}\d*\.{0,1}\d+$/
		INTEGER_RE = /\-{0,1}A[+-]?\d+\Z/

    def validates_inclusion_of( *attributes )
      options = { 
        :message => 'is not in the required range' 
      }.merge!( attributes.extract_options! )

      validates_each( *attributes ) do |object, attribute, value|
        next if ( value.nil? && options[ :allow_nil ]) || ( value.blank? && options[ :allow_blank ])
        unless options[ :in ].include?( value )
          object.errors[ attribute ] << options[ :message ]
        end
      end
    end

    def validates_validity_of( *attributes )
      options = {
        :message => 'is not valid'
      }.merge!( attributes.extract_options! )

      validates_each( *attributes ) do |object, attribute, value|
        next if ( value.nil? && options[ :allow_nil ]) || ( value.blank? && options[ :allow_blank ])
        unless value.valid?
          object.errors[ attribute ] << options[ :message ]
        end
      end
    end

    def validates_validity_of_collection( *attributes )
      options = {
        :message => 'contains an invalid element'
      }.merge!( attributes.extract_options! )

      validates_each( *attributes ) do |object, attribute, collection|
        next if ( collection.nil? && options[ :allow_nil ]) || ( collection.blank? && options[ :allow_blank ])
        unless collection.all?{ |element| element.valid? }
          object.errors[ attribute ] << options[ :message ]
        end
      end
    end

    def validates_responsiveness_of( *attributes )
      options = {
        :message => 'does not respond to the given method'
      }.merge!( attributes.extract_options! )

      validates_each( *attributes ) do |object, attribute, value|
        next if ( collection.nil? && options[ :allow_nil ]) || ( collection.blank? && options[ :allow_blank ])
        unless options[ :to ].all?{ |method_name| object.respond_to?( method_name )}
          object.errors[ attribute ] << options [ :message ]
        end
      end
    end
  end
end
