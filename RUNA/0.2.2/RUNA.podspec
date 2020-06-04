#
#  Be sure to run `pod spec lint RUNA.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "RUNA"
  s.version      = "0.2.2"
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
    :http => "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/#{s.version}/RUNABanner_iOS_#{s.version}.framework.zip"
  }

  s.default_subspec = 'Banner'

  s.subspec 'CoreOnly' do |ss|
    ss.ios.dependency 'RUNACore', '0.2.1'
  end

  s.subspec 'Banner' do |ss|
    ss.dependency 'RUNA/CoreOnly'
    ss.ios.dependency 'RUNABanner', '0.2.2'
  end

  s.subspec 'A2A' do |ss|
    ss.dependency 'RUNA/CoreOnly'
    ss.ios.dependency 'RUNAA2A', '0.2.0'
  end

  s.subspec 'OpenMeasurement' do |ss|
    ss.dependency 'RUNA/CoreOnly'
    ss.dependency 'RUNA/Banner'
    ss.ios.dependency 'RUNAOMAdapter', '0.2.0'
  end

end
