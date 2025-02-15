#
#  Be sure to run `pod spec lint RUNA.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "RUNA"
  s.version      = "1.16.3"
  s.swift_version = '5.0'
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
  s.platform     = :ios, "13.0"
  s.source       = {
    :git => "https://github.com/rakuten-ads/Rakuten-Ads-iOS.git"
  }

  s.default_subspec = 'Banner'

  s.subspec 'CoreOnly' do |ss|
    ss.ios.dependency 'RUNACore', '1.8.5'
  end

  s.subspec 'Banner' do |ss|
    ss.dependency 'RUNA/CoreOnly'
    ss.ios.dependency 'RUNABanner', '1.14.6'
  end

  s.subspec 'OMSDK' do |ss|
    ss.ios.dependency 'RUNAOMSDK', '1.4.13'
  end

  s.subspec 'OMAdapter' do |ss|
    ss.dependency 'RUNA/Banner'
    ss.dependency 'RUNA/OMSDK'
    ss.ios.dependency 'RUNAOMAdapter', '1.3.2'
  end

  s.subspec 'MediationAdapter' do |ss|
    ss.dependency 'RUNA/Banner'
    ss.ios.dependency 'Google-Mobile-Ads-SDK', '~> 11.5'
    ss.ios.dependency 'RUNAMediationAdapter', '1.0.1'
  end

end
