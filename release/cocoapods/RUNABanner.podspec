#
#  Be sure to run `pod spec lint RUNA.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "RUNABanner"
  s.version      = "1.5.0"
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
    :http => "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/#{s.name}/#{s.name}_iOS_#{s.version}.framework.zip"
  }
  s.vendored_frameworks = "Carthage/Build/iOS/#{s.name}.framework"

  s.frameworks = "Foundation", "AdSupport", "SystemConfiguration", "WebKit", "UIKit"
  s.dependency 'RUNACore', '~> 1.4'
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 armv7' }

end
