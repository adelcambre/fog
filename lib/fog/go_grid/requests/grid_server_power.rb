module Fog
  module GoGrid
    class Real

      # Start, Stop or Restart a server
      #
      # ==== Parameters
      # * 'server'<~String> - id or name of server to power
      # * 'power'<~String>  - power operation, in ['restart', 'start', 'stop']
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Array>:
      # TODO: docs
      def grid_server_delete(server, power)
        request(
          :path     => 'grid/server/power',
          :query    => {'server' => server}
        )
      end

    end

    class Mock

      def grid_server_delete(server)
        Fog::Mock.not_implemented
      end

    end
  end
end
