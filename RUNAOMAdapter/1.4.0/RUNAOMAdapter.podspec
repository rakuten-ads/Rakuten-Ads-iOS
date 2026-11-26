#
#  Be sure to run `pod spec lint RUNA.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "RUNAOMAdapter"
  s.version      = "1.4.0"
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
  s.platform     = :ios, "15.0"
  s.source       = {
    :http => "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/#{s.name}/#{s.name}_iOS_#{s.version}.xcframework.zip",
    :sha256 => "22a704890dd4a0c40549c596125b9dcdf2653fd72d9ef0e90ebbad025d18339c"
  }
  s.vendored_frameworks = "#{s.name}.xcframework"

  s.frameworks = "Foundation", "AdSupport", "SystemConfiguration", "WebKit", "UIKit"
  s.dependency 'RUNABanner', '~> 1.18'
  s.dependency 'RUNAOMSDK', '~> 1.6.12'

end
