module CustomFields

  module Types

    module RemoteSource

      module Field; end

      module Target

        extend ActiveSupport::Concern

        module ClassMethods

          # Adds a remote_source field
          #
          # @param [ Class ] klass The class to modify
          # @param [ Hash ] rule It contains the name of the field and if it is required or not
          #
          def apply_remote_source_custom_field(klass, rule)
            klass.field rule['name'], :localize => rule['localized'] || false
            klass.field "#{rule['name']}_expiry", :localize => false, :type => Integer, :default => 1.minute

            klass.validates_format_of rule['name'], :with => URI.regexp, :allow_blank => true
            if rule['required']
              klass.validates_presence_of rule['name']
            end
          end

        end

      end

    end

  end

end