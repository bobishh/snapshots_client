module TimelapserClient
  class Command
    module Templates
      class RaspistillTemplate
        COMMAND_TEMPLATE = 'raspistill -n -dt -o %{image_path}'

        def self.evaluate(data)
          COMMAND_TEMPLATE % data
        end
      end

      class ImageSnapTemplate
        def self.evaluate(data)
          'imagesnap -w 1 %{image_path}' % data
        end
      end
    end
  end
end
