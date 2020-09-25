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

6. Set env of Github access token

`FASTLANE_GITHUB_TOKEN`


7. usage sample:
- `bundle exec fastlane release sdk_dryrun:true module:Core=0.2.1,Banner=0.2.2 sdk_skip_build:true`
- `bundle exec fastlane release`

8. test podspec local:
- `pod spec lint --private --sources=/Users/localuser/.cocoapods/repos/Rakuten-Ads-iOS --subspec=RUNA/A2A RUNA.podspec`