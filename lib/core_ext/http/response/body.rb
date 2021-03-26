module HTTP
  class Response
    class Body
      def to_s
        return @contents if @contents

        raise StateError, "body is being streamed" unless @streaming.nil?

        begin
          encoding = Encoding.find @encoding
        rescue ArgumentError
          encoding = Encoding::BINARY
        end

        begin
          @streaming  = false
          @contents   = String.new("").force_encoding(encoding)

          while (chunk = @stream.readpartial)
            @contents << (+chunk).force_encoding(encoding)
          end
        rescue
          @contents = nil
          raise
        end

        @contents
      end
    end
  end
end
