#
#  Be sure to run `pod spec lint RPSRDN.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "RPSRDN.dev"
  s.version      = "0.0.1"
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
  s.platform     = :ios, "11.0"
  s.source       = {
    :http => "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/dev/#{s.version}/RPSRDN_iOS_#{s.version}.framework.zip"
  }
  s.vendored_frameworks = "Carthage/Build/iOS/RPSRDN.framework"

  s.frameworks = "Foundation", "AdSupport", "SystemConfiguration", "WebKit", "UIKit"
end
