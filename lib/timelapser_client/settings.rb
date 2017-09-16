require 'yaml'

module TimelapserClient
  # reads yaml config and return values from it
  class Settings
    CONFIG_PATH = File.expand_path('../../../config/secrets.yml', __FILE__)

    METHODS = %w(token camera_id endpoint snapshots_path env).freeze
    class << self
      def settings
        @settings ||= YAML.safe_load(File.read(CONFIG_PATH))
      end

      METHODS.each do |method_name|
        define_method method_name do
          settings.dig('timelapser_client', method_name)
        end
      end
    end
  end
end
