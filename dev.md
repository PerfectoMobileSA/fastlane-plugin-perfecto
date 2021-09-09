Run the following commands to setup & execute the local fastlane project:

    bundle check || bundle install --jobs=4 --retry=3 --path vendor/bundle
    bundle exec rake

Push to github after changes and release plugin:
    rake release