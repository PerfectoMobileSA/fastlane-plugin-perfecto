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
        uri = URI.parse(perfecto_cloudurl)
        response = RestClient::Request.execute(
          url: 'https://' + uri.host + '/repository/api/v1/artifacts',
          method: :post,
          headers: {
            'Accept' => 'application/json',
            'Content-Type' => 'multipart/form-data',
            'PERFECTO_AUTHORIZATION' => perfecto_token
          },
          payload: {
            multipart: true,
            inputStream: File.open(file_path, "rb"),
            requestPart: {
              artifactLocator: "PUBLIC:BUILDS/EMS/EMS_QA/app-release.qa.apk",
              artifactType: "ANDROID",
              override: true
            }.to_json
          }
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
