#
#  Be sure to run `pod spec lint RUNA.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "RUNAOMAdapter"
  s.version      = "1.0.1"
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
    :http => "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/#{s.version}/#{s.name}_iOS_#{s.version}.framework.zip",
    :sha256 => "8b29e8e40cb1dd954b2d5392f4d22398b0ec609b7a5a337b25a2cd9a39e78bad"
  }
  s.vendored_frameworks = "Carthage/Build/iOS/#{s.name}.framework"

  s.frameworks = "Foundation", "AdSupport", "SystemConfiguration", "WebKit", "UIKit"
  s.dependency 'RUNABanner', '~> 1.1.1'
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 armv7' }

end
