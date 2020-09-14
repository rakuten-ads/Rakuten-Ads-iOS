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
`bundle exec pod repo add rakuten-ads git@github.com:rakuten-ads/Rakuten-Ads-iOS.git`

6. Set env of Github access token

`FASTLANE_GITHUB_TOKEN`
