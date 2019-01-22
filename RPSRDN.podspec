#
#  Be sure to run `pod spec lint RPSRDN.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "RPSRDN"
  s.version      = "1.0.0"
  s.summary      = "Podspec file of RPSRDN iOS SDK."
  s.description  = <<-DESC
This repository is used to distribute RPSRDN iOS SDK for CocoaPods users.
                   DESC
  s.homepage     = "https://github.com/lob-inc/RPSRDN.ios.repo"
  s.license      = {
    :type => "Copyright",
    :text => "Copyright © LOB, inc. All Rights Reserved."
  }
  s.author       = "LOB-INC"
  s.platform     = :ios, "9.0"
  s.source       = {
    :http => "https://dev-s-cdn.rx-ad.com/sdk/ios/#{s.version}/RPSRDN_iOS_static_#{s.version}.zip"
  }
  s.vendored_frameworks = "RPSRDN_iOS_static_#{s.version}/RPSRDN.framework"

  s.frameworks = "Foundation", "AdSupport", "SystemConfiguration", "WebKit", "UIKit"
end
