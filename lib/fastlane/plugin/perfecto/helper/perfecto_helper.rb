require "rest-client"
require "uri"
require "fastlane_core/ui/ui"
require "json"
require "net/http"

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
      # DEPRECATED
      def self.upload_file(perfecto_cloudurl, perfecto_token, file_path, perfecto_media_fullpath)
        unless ENV["http_proxy"]
          RestClient.proxy = ENV["http_proxy"]
        end
        response = RestClient::Request.execute(
          url: "https://" + perfecto_cloudurl + "/services/repositories/media/" + perfecto_media_fullpath + "?operation=upload&overwrite=true&securityToken=" + URI.encode(perfecto_token, "UTF-8"),
          method: :post,
          headers: {
            "Accept" => "application/json",
            "Content-Type" => "application/octet-stream",
            "Expect" => "100-continue",
          },
          payload: File.open(file_path, "rb"),
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

      def self.parameters(requestPart, key, value)
        unless value.to_s.strip.empty?
          return requestPart.merge!({ key => value })
        end
      end

      # Uploads file to Perfecto using new V1 upload API
      # Params :
      # +perfecto_cloudurl+:: Perfecto's cloud name.
      # +perfecto_token+:: Perfecto's security token.
      # +file_path+:: Path to the file to be uploaded.
      # +perfecto_media_fullpath+:: Path to the perfecto media location
      # +artifactType+:: Artifact Type
      # +artifactName+:: Artifact Name
      def self.uploadV1(perfecto_cloudurl, perfecto_token, file_path, perfecto_media_fullpath, artifactType, artifactName)
        # prepare cloud url
        unless !perfecto_cloudurl.include? ".perfectomobile.com"
          perfecto_cloudurl = perfecto_cloudurl.split(".perfectomobile.com")[0]
          unless !perfecto_cloudurl.include? ".app"
            perfecto_cloudurl = perfecto_cloudurl.split(".app")[0]
          end
        end

        url = URI("https://" + perfecto_cloudurl + ".app.perfectomobile.com/repository/api/v1/artifacts")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(url)
        request["Perfecto-Authorization"] = perfecto_token
        requestPart = { "artifactLocator" => perfecto_media_fullpath, "override" => true }
        parameters(requestPart, "artifactType", artifactType)
        parameters(requestPart, "artifactName", artifactName)
        requestPart = requestPart.to_json.to_s.gsub("=>", ":")
        # Debug: puts requestPart
        form_data = [["requestPart", requestPart], ["inputStream", File.open(file_path, "rb")]]
        request.set_form form_data, "multipart/form-data"
        response = https.request(request)
        UI.message(response.inspect)
        if response.code != "200"
          # Give error if upload failed.
          UI.user_error!("App upload failed!!! Reason : #{response}")
        end
      end
    end
  end
end
