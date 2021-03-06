module Fog
  module Parsers
    module AWS
      module S3

        class GetBucketVersioning < Fog::Parsers::Base

          def reset
            @response = { 'VersioningConfiguration' => {} }
          end

          def end_element(name)
            case name
            when 'Status'
              @response['VersioningConfiguration'][name] = @value
            end
          end

        end

      end
    end
  end
end
