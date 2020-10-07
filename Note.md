## Xcode Settings for New Project

- Project Deployment Target >= iOS 10.0
- Create a PrefixHeader.pch and apply to precompile. Like `RUNA/RUNA/PrefixHeader.pch`.
- Link library `RUNACore.Framework`

## Require for Release

1. carthage. 

`brew install carthage`

2. cocoapods

`brew install cocoapods`

3. gem

`gem install bundler -i .`

`bundle install --path .`

4. gcloud credential file of bucket

`gcloud auth application-default login`

5. cocoapods
`bundle exec pod repo add Rakuten-Ads-iOS git@github.com:rakuten-ads/Rakuten-Ads-iOS.git`

6. set env of Github access token

`FASTLANE_GITHUB_TOKEN`

7. usage sample:

- `bundle exec fastlane release sdk_dryrun:true module:Core=0.2.1,Banner=0.2.2 sdk_skip_build:true`
- `bundle exec fastlane release`

## Test

1. local only podsepc lint

`pod spec lint --private --sources=Rakuten-Ads-iOS --subspec=RUNA/Banner RUNA/1.1.1/RUNA.podspec`

2. loging

```sh
# show config
xcrun simctl spawn booted log config --status --subsystem com.rakuten.ad.runa

# set debug level
xcrun simctl spawn booted log config --mode "level:debug" --subsystem com.rakuten.ad.runa
xcrun simctl spawn booted log config --mode "persist:debug" --subsystem com.rakuten.ad.runa

# reset debug level
xcrun simctl spawn booted log config --reset --subsystem com.rakuten.ad.runa

# show log from 2 minutes ago
xcrun simctl spawn booted log show --debug --info --predicate '(subsystem == "com.rakuten.ad.runa")' --last 2m

# stream log
xcrun simctl spawn booted log stream\
 --level debug\
 --style syslog\
 --color none\
 --predicate 'subsystem contains "com.rakuten.ad.runa"'
```