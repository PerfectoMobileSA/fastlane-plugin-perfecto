# perfecto plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-perfecto)
[![CircleCI](https://circleci.com/gh/PerfectoMobileSA/fastlane-plugin-perfecto/tree/master.svg?style=svg)](https://circleci.com/gh/PerfectoMobileSA/fastlane-plugin-perfecto/tree/master)


## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-perfecto`, add it to your project by running:

```bash
fastlane add_plugin perfecto
```

## About plugin

This plugin allows you to automatically upload ipa/apk files to Perfecto for manual/automation testing

## Updates
This plugin uses [latest v1 upload media API](https://help.perfecto.io/perfecto-help/content/perfecto/automation-testing/upload_item_to_repository.htm) under the hood and supports all file types.


## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.
You can easily upload your ipa/apk file using perfecto fastlane Plugin and execute your test on perfecto cloud.

Add the below action in your fastfile to utilize this plugin.  

```
lane :test do
  perfecto(
    perfecto_cloudurl: ENV["PERFECTO_CLOUDURL"],
    perfecto_token: ENV["PERFECTO_TOKEN"],
    perfecto_media_location: ENV["PERFECTO_MEDIA_LOCATION"],
    file_path: ENV['GRADLE_APK_OUTPUT_PATH']
  )
end
```

Optional parameters:

```
    artifactType: ENV["artifactType"],
    artifactName: ENV["artifactName"],
```

### Note: <br>
Pass the below variable values as environment variables:<br>
&nbsp;  * PERFECTO_CLOUDURL  [your perfecto cloud url. E.g.: demo.perfectomobile.com]<br>
&nbsp;	* PERFECTO_TOKEN [your perfecto [`security token`](https://developers.perfectomobile.com/display/PD/Generate+security+tokens)]<br>
&nbsp;	* PERFECTO_MEDIA_LOCATION	[mention the Perfecto media repository location to upload the file mentioned in file_path. E.g. PUBLIC:Samples/sample.ipa]<br>
&nbsp;	* file_path [location of your preferred ipa/apk file which needs to be uploaded to perfecto media repository.]<br>
&nbsp; * artifactType  [Optional: Defines the artifact types, options: GENERAL, IOS, SIMULATOR, ANDROID, IMAGE, AUDIO, VIDEO, SCRIPT]<br>
&nbsp; * artifactName  [Optional: Used for the representation of the artifact when downloaded.]<br>

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Sample project: <br>

Here's a [`sample project`](https://github.com/PerfectoMobileSA/FastlaneEspressoCircleCISlackSample) which demonstrates the usage of this plugin. 

The following actions are possible with the [`sample project`](https://github.com/PerfectoMobileSA/FastlaneEspressoCircleCISlackSample):

## Available Actions:
## Android
### android test
```
fastlane android test
```
build, upload and run on perfecto
### android apk
```
fastlane android apk
```
Build debug APK and upload to perfecto
### android test_apk
```
fastlane android test_apk
```
Build debug test APK and upload to perfecto
### android run_perfecto
```
fastlane android run_perfecto
```
Run on perfecto
### android slack_report
```
fastlane android slack_report
```
Report perfecto url to slack

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).