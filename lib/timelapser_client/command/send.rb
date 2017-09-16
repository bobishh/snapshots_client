# frozen_string_literal: true

require 'net/http'
require 'json'
require 'base64'

module TimelapserClient
  class Command
    # sends image to api
    class Send
      OBJECT_NAME = 'snapshot'
      attr_reader :errors

      def initialize(options)
        @image = options[:image]
        @endpoint = options[:endpoint]
        @camera_id = options[:camera_id]
        @token = options[:token]
        @object_name = options[:object_name] || OBJECT_NAME
      end

      def command
        @command ||= begin
                       request = Net::HTTP::Post.new(uri,
                                                     'Content-Type' => 'application/json',
                                                     'X-Auth-Token' => @token)
                       request.body = request_body
                       request
                     end
      end

      def run!
        call_command
        if success?
          { success: true, id: returned_id }
        else
          { success: false, errors: errors }
        end
      end

      private

      def http
        @http = Net::HTTP
      end

      def request_body
        JSON.generate({ snapshot: { file: image_file,
                                    taken: Time.now.to_datetime,
                                    camera_id: @camera_id }})
      end

      def success?
        @status.is_a? Net::HTTPCreated
      end

      def uri
        URI(@endpoint)
      end

      def returned_id
        JSON.parse(@status.body).dig('snapshot', 'id')&.to_i
      end

      def image_file
        @image_file ||= Base64.encode64(File.read(@image))
      end

      def call_command
        begin
          Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
            @status = http.request(command)
            @errors = JSON.parse(@status.body)['errors'] unless success?
          end
        rescue StandardError => e
          @status = nil
          @errors = e.message
        end
      end
    end
  end
end
