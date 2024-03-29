describe Fastlane::Actions::PerfectoAction do
  describe "perfecto" do
    it "should work with correct parameters & IPA file" do
      Fastlane::FastFile.new.parse("lane :test do
          perfecto({
            perfecto_cloudurl: ENV['PERFECTO_CLOUDURL'],
            perfecto_token: ENV['PERFECTO_TOKEN'],
            perfecto_media_location: 'PUBLIC:Samples/sample.ipa',
            file_path: File.join(SAMPLE_PATH, 'sample.ipa')
          })
        end").runner.execute(:test)
      expect(ENV["PERFECTO_MEDIA_FULLPATH"]).to satisfy { |value| !value.to_s.empty? }
    end

    it "should work with correct parameters & apk file" do
      Fastlane::FastFile.new.parse("lane :test do
          perfecto({
            perfecto_cloudurl: ENV['PERFECTO_CLOUDURL'],
            perfecto_token: ENV['PERFECTO_TOKEN'],
            perfecto_media_location: 'PUBLIC:Samples/sample.apk',
            file_path: File.join(SAMPLE_PATH, 'app-debug.apk')
          })
        end").runner.execute(:test)
      expect(ENV["PERFECTO_MEDIA_FULLPATH"]).to satisfy { |value| !value.to_s.empty? }
    end

    it "should work with all correct parameters & IPA file" do
      Fastlane::FastFile.new.parse("lane :test do
          perfecto({
            perfecto_cloudurl: ENV['PERFECTO_CLOUDURL'],
            perfecto_token: ENV['PERFECTO_TOKEN'],
            artifactType: 'IOS',
            artifactName: 'testing.ipa',
            perfecto_media_location: 'PUBLIC:Samples/sample.ipa',
            file_path: File.join(SAMPLE_PATH, 'sample.ipa')
          })
        end").runner.execute(:test)
      expect(ENV["PERFECTO_MEDIA_FULLPATH"]).to satisfy { |value| !value.to_s.empty? }
    end

    it "should work with all correct parameters & APK file" do
      Fastlane::FastFile.new.parse("lane :test do
          perfecto({
            perfecto_cloudurl: ENV['PERFECTO_CLOUDURL'],
            perfecto_token: ENV['PERFECTO_TOKEN'],
            artifactType: 'ANDROID',
            artifactName: 'testing.apk',
            perfecto_media_location: 'PUBLIC:Samples/sample.apk',
            file_path: File.join(SAMPLE_PATH, 'app-debug.apk')
          })
        end").runner.execute(:test)
      expect(ENV["PERFECTO_MEDIA_FULLPATH"]).to satisfy { |value| !value.to_s.empty? }
    end

    it "should work with all correct parameters & ZIP file" do
      Fastlane::FastFile.new.parse("lane :test do
          perfecto({
            perfecto_cloudurl: ENV['PERFECTO_CLOUDURL'],
            perfecto_token: ENV['PERFECTO_TOKEN'],
            artifactType: 'SIMULATOR',
            artifactName: 'testing.zip',
            perfecto_media_location: 'PUBLIC:Samples/sample.zip',
            file_path: File.join(SAMPLE_PATH, 'Test.app.zip')
          })
        end").runner.execute(:test)
      expect(ENV["PERFECTO_MEDIA_FULLPATH"]).to satisfy { |value| !value.to_s.empty? }
    end

    it "should work with all correct parameters & jpg file" do
      Fastlane::FastFile.new.parse("lane :test do
          perfecto({
            perfecto_cloudurl: ENV['PERFECTO_CLOUDURL'],
            perfecto_token: ENV['PERFECTO_TOKEN'],
            artifactType: 'IMAGE',
            perfecto_media_location: 'PUBLIC:Samples/sample.zip',
            file_path: File.join(SAMPLE_PATH, 'blue.jpg')
          })
        end").runner.execute(:test)
      expect(ENV["PERFECTO_MEDIA_FULLPATH"]).to satisfy { |value| !value.to_s.empty? }
    end

    it "should work with correct parameters coming from env file" do
      Fastlane::FastFile.new.parse("lane :test do
          perfecto({
            perfecto_cloudurl: ENV['PERFECTO_CLOUDURL'],
            perfecto_token: ENV['PERFECTO_TOKEN'],
            perfecto_media_location: ENV['PERFECTO_MEDIA_LOCATION'],
            file_path: ENV['file_path']
          })
        end").runner.execute(:test)
      expect(ENV["PERFECTO_MEDIA_FULLPATH"]).to satisfy { |value| !value.to_s.empty? }
    end

    it "should work with correct parameters & dummy proxy" do
      ENV["http_proxy"] = "google.com"
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          perfecto({
            perfecto_cloudurl: ENV['PERFECTO_CLOUDURL'],
            perfecto_token: ENV['PERFECTO_TOKEN'],
            perfecto_media_location: ENV['PERFECTO_MEDIA_LOCATION'],
            file_path: File.join(SAMPLE_PATH, 'sample.ipa')
          })
        end").runner.execute(:test)
      end.to raise_error(/.*nodename nor servname provided.*|.*Name or service not known.*/)
    end
    it "raise an error with correct parameters but no file_path extension" do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
            perfecto({
              perfecto_cloudurl: ENV['PERFECTO_CLOUDURL'],
              perfecto_token: ENV['PERFECTO_TOKEN'],
              perfecto_media_location: ENV['PERFECTO_MEDIA_LOCATION'],
              file_path: File.join(SAMPLE_PATH, 'blue')
              })
          end").runner.execute(:test)
      end.to raise_error("No file found at filepath parameter location.")
    end

    it "raise an error with correct parameters but invalid cloud url" do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
            perfecto({
              perfecto_cloudurl: 'invalid',
              perfecto_token: ENV['PERFECTO_TOKEN'],
              perfecto_media_location: ENV['PERFECTO_MEDIA_LOCATION'],
              file_path: File.join(SAMPLE_PATH, 'sample.ipa')
              })
          end").runner.execute(:test)
      end.to raise_error(/.*nodename nor servname provided.*|.*Name or service not known.*/)
    end

    it "raise an error with correct parameters but invalid token" do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
            perfecto({
              perfecto_cloudurl: ENV['PERFECTO_CLOUDURL'],
              perfecto_token: 'token',
              perfecto_media_location: ENV['PERFECTO_MEDIA_LOCATION'],
              file_path: File.join(SAMPLE_PATH, 'sample.ipa')
              })
          end").runner.execute(:test)
      end.to raise_error(/.*nodename nor servname provided.*|.*Name or service not known.*/)
    end

    # it "raise an error with correct parameters but invalid media location & invalid extension" do
    #   expect do
    #     Fastlane::FastFile.new.parse("lane :test do
    #         perfecto({
    #           perfecto_cloudurl: ENV['PERFECTO_CLOUDURL'],
    #           perfecto_token: ENV['PERFECTO_TOKEN'],
    #           perfecto_media_location: ('blue.jpg'),
    #           file_path: File.join(SAMPLE_PATH, 'sample.ipa')
    #           })
    #       end").runner.execute(:test)
    #   end.to raise_error("perfecto_media_location is invalid, only files with extensions with .ipa or .apk are allowed to be uploaded.")
    # end

    it "raise an error with correct parameters but invalid media location but valid extension" do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
            perfecto({
              perfecto_cloudurl: ENV['PERFECTO_CLOUDURL'],
              perfecto_token: ENV['PERFECTO_TOKEN'],
              perfecto_media_location: 'TEST:test/blue.ipa',
              file_path: File.join(SAMPLE_PATH, 'sample.ipa')
              })
          end").runner.execute(:test)
      end.to raise_error(/.*nodename nor servname provided.*|.*Name or service not known.*/)
    end

    it "raises an error if PERFECTO_CLOUDURL is not provided" do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          perfecto({})
        end").runner.execute(:test)
      end.to raise_error("No perfecto_cloudurl given.")
    end

    it "raises an error if no perfecto_token is given" do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          perfecto({
            perfecto_cloudurl: 'PERFECTO_CLOUDURL'
          })
        end").runner.execute(:test)
      end.to raise_error("No perfecto_token given.")
    end

    it "raises an error if no perfecto_media_location is given" do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          perfecto({
            perfecto_cloudurl: 'PERFECTO_CLOUDURL',
            perfecto_token: 'perfecto_token'
          })
        end").runner.execute(:test)
      end.to raise_error("No perfecto_media_location given.")
    end
    it "raises an error if just perfecto is called" do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          perfecto()
        end").runner.execute(:test)
      end.to raise_error("No perfecto_cloudurl given.")
    end
  end
end
