module CustomFields

  module Types

    module RemoteSource

      module Field
      
        extend ActiveSupport::Concern
        
        included do

          field :text_formatting, :default => 'text'

        end

      
      end

      module Target

        extend ActiveSupport::Concern

        module ClassMethods

          # Adds a remote_source field
          #
          # @param [ Class ] klass The class to modify
          # @param [ Hash ] rule It contains the name of the field and if it is required or not
          #
          def apply_remote_source_custom_field(klass, rule)
            apply_custom_field(klass, rule)
            if rule['required']
              klass.validates_format_of rule['name'], :with => URI.regexp
            end
          end

        end

      end

    end

  end

end