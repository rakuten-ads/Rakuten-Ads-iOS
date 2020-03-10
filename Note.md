## Xcode Settings for New Project

- Project Deployment Target >= iOS 9.0
- Create a PrefixHeader.pch and apply to precompile. Like `RUNA/RUNA/PrefixHeader.pch`.
- Link library `RUNACore.Framework`

## Require for Release

1. carthage. like `brew install carthage`

2. gem

`gem install bundler`

`bundle install`

3. gcloud credential file of bucket

`gcloud auth application-default login`

4. cocoapods
`pod repo add Rakuten-Ads-iOS git@github.com:rakuten-ads/Rakuten-Ads-iOS.git`

5. Set env of Github access token

`GITHUB_API_TOKEN`
