require 'rest-client'
require 'uri'
require 'fastlane_core/ui/ui'
require 'json'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class PerfectoHelper
      # Uploads file to Perfecto
      # Params :
      # +perfecto_cloudurl+:: Perfecto's cloud name.
      # +perfecto_token+:: Perfecto's security token.
      # +file_path+:: Path to the file to be uploaded.
      # +perfecto_media_fullpath+:: Path to the perfecto media location
      def self.upload_file(perfecto_cloudurl, perfecto_token, file_path, perfecto_media_fullpath)
        unless ENV['http_proxy']
          RestClient.proxy = ENV['http_proxy']
        end
        response = RestClient::Request.execute(
          url: 'https://' + perfecto_cloudurl + '/services/repositories/media/' + perfecto_media_fullpath + '?operation=upload&overwrite=true&securityToken=' + URI.encode(perfecto_token, "UTF-8"),
          method: :post,
          headers: {
            'Accept' => 'application/json',
            'Content-Type' => 'application/octet-stream',
            'Expect' => '100-continue'
          },
          payload: File.open(file_path, "rb")
        )
        UI.message(response.inspect)
      rescue RestClient::ExceptionWithResponse => err
        begin
          error_response = err.response.to_s
        rescue
          error_response = "Internal server error"
        end
        # Give error if upload failed.
        UI.user_error!("App upload failed!!! Reason : #{error_response}")
      rescue StandardError => error
        UI.user_error!("App upload failed!!! Reason : #{error.message}")
      end
    end
  end
end
