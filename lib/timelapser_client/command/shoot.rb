require 'timelapser_client/command/templates'

# takes shot for further sending

module TimelapserClient
  class Command
    class Shoot
      def default_template
        ::TimelapserClient::Command::Templates::RaspistillTemplate
      end

      def initialize(options)
        @result_path = options[:result_path]
        @template = options[:template] || default_template
      end

      def run!
        @result = { image: image_path, success: call_result }
      end

      def call_result
        @call_result ||= system(command)
      end

      def image_path
        File.join(@result_path, image_filename)
      end

      def image_filename
        Time.now.strftime('snapshot_%Y%m%d_%H%M.jpg')
      end

      def command
        @command =@template.evaluate(image_path: image_path)
      end
    end
  end
end
