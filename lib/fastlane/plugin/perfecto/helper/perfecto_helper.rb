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
            "Expect" => "100-continue"
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

      def self.parameters(request_part, key, value)
        unless value.to_s.strip.empty?
          return request_part.merge!(key => value)
        end
      end

      # Uploads file to Perfecto using new V1 upload API
      # Params :
      # +perfecto_cloudurl+:: Perfecto's cloud name.
      # +perfecto_token+:: Perfecto's security token.
      # +file_path+:: Path to the file to be uploaded.
      # +perfecto_media_fullpath+:: Path to the perfecto media location
      # +artifact_type+:: Artifact Type
      # +artifact_name+:: Artifact Name
      def self.upload_v1(perfecto_cloudurl, perfecto_token, file_path, perfecto_media_fullpath, artifact_type, artifact_name)
        # prepare cloud url
        if perfecto_cloudurl.include?(".perfectomobile.com")
          perfecto_cloudurl = perfecto_cloudurl.split(".perfectomobile.com")[0]
          if perfecto_cloudurl.include?(".app")
            perfecto_cloudurl = perfecto_cloudurl.split(".app")[0]
          end
        end

        url = URI("https://" + perfecto_cloudurl + ".app.perfectomobile.com/repository/api/v1/artifacts")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(url)
        request["Perfecto-Authorization"] = perfecto_token
        request_part = { "artifactLocator" => perfecto_media_fullpath, "override" => true }
        parameters(request_part, "artifactType", artifact_type)
        parameters(request_part, "artifactName", artifact_name)
        request_part = request_part.to_json.to_s.gsub("=>", ":")
        # Debug: puts request_part
        form_data = [["requestPart", request_part], ["inputStream", File.open(file_path, "rb")]]
        request.set_form(form_data, "multipart/form-data")
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
