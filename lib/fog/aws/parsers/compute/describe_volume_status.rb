module Fog
  module Parsers
    module Compute
      module AWS
        class DescribeVolumeStatus < Fog::Parsers::Base
          # <?xml version="1.0" encoding="UTF-8"?>
          # <DescribeVolumeStatusResponse xmlns="http://ec2.amazonaws.com/doc/2012-03-01/">
          #     <requestId>af8dd421-f9c2-434a-8f20-363d4bf475a8</requestId>
          #     <volumeStatusSet>
          #         <item>
          #             <volumeId>vol-b93655d4</volumeId>
          #             <availabilityZone>us-east-1b</availabilityZone>
          #             <volumeStatus>
          #                 <status>impaired</status>
          #                 <details>
          #                     <item>
          #                         <name>io-enabled</name>
          #                         <status>failed</status>
          #                     </item>
          #                 </details>
          #             </volumeStatus>
          #             <eventsSet>
          #                 <item>
          #                     <description>Awaiting Action: Enable IO</description>
          #                     <notBefore>2012-06-15T07:43:54.000Z</notBefore>
          #                     <eventId>evol-a4ed0bcd</eventId>
          #                     <eventType>potential-data-inconsistency</eventType>
          #                 </item>
          #             </eventsSet>
          #             <actionsSet>
          #                 <item>
          #                     <description>Action requried: Verify data consistency and enable IO.</description>
          #                     <code>enable-volume-io</code>
          #                     <eventId>evol-a4ed0bcd</eventId>
          #                     <eventType>potential-data-inconsistency</eventType>
          #                 </item>
          #             </actionsSet>
          #         </item>
          #     </volumeStatusSet>
          # </DescribeVolumeStatusResponse>


          def new_volume
            @volume = { 'volumeStatus' => { 'details' => [] }, 'eventsSet' => [], 'actionsSet' => [] }
          end

          def reset
            @volume_status = {}
            @response = { 'volumeStatusSet' => [] }
            @inside = nil
            @current_item = nil
          end

          def start_element(name, attrs=[])
            super
            case name
            when 'item'
              if @inside.nil?
                new_volume
              else
                @current_item = {}
              end
            when 'volumeStatus'
              @inside = :volume_status
            when 'details'
              @inside = :details
            when 'eventsSet'
              @inside = :eventsSet
            when 'actionsSet'
              @inside = :actionsSet
            end
          end

          def end_element(name)
            if name != "item" && @current_item
              if name =~ /(After|Before)$/
                @current_item[name] = Time.parse(value)
              else
                @current_item[name] = value
              end
            else
              case name
              #Simple closers
              when 'details'
                @inside = nil
              when 'volumeStatus'
                @inside = nil
              when 'eventsSet'
                @inside = nil
              when 'actionsSet'
                @inside = nil
              when 'item'
                if @inside.nil?
                  @response['volumeStatusSet'] << @volume
                else
                  @volume[@inside.to_s] = @current_item
                  @current_item = nil
                end
              #Top level
              when 'nextToken', 'requestId'
                @response[name] = value
              # Volume Stuff
              when 'volumeId', 'availabilityZone'
                @volume[name] = value
              #The mess...
              when 'name', 'status'
                case @inside
                when :volume_status
                  @volume['volumeStatus'][name] = value
                end
              end
            end
          end
        end
      end
    end
  end
end
