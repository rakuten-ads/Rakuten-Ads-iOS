#
#  Be sure to run `pod spec lint RUNACore.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "RUNAOMSDK"
  s.version      = "1.4.11"
  s.summary      = "Podspec file of #{s.name} iOS SDK."
  s.description  = <<-DESC
This repository is used to distribute #{s.name} iOS SDK for CocoaPods users.
                   DESC
  s.homepage     = "https://github.com/rakuten-ads/Rakuten-Ads-iOS"
  s.license      = {
    :type => "Copyright",
    :text => "Copyright © Rakuten, inc. All Rights Reserved."
  }
  s.author       = "Rakuten"
  s.platform     = :ios, "10.0"
  s.source       = {
    :http => "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/#{s.name}/#{s.name}_iOS_#{s.version}.xcframework.zip",
    :sha256 => "4447450ee4f45c30cf53615f273f2dfda81fada03e79dec9b4f93a8a32e9319c"
  }
  s.vendored_frameworks = "OMSDK_Rakuten.xcframework"

  s.frameworks = "Foundation", "UIKit"

end
