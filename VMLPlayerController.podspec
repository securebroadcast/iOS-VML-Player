#
#  Be sure to run `pod spec lint VMLPlayerController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "VMLPlayerController"
  spec.version      = "0.0.2t"
  spec.summary      = "VMLPlayerController"

  spec.homepage     = "https://github.com/securebroadcast/iOS-VML-Player"

  spec.authors      = "Jordan Carroll", "Kris Jones", "Frazer Robinson"
  spec.license      = "MIT"

  spec.platform     = :ios, "12.0"
  spec.swift_version = "5.0"

  spec.source       = { :git => "https://github.com/securebroadcast/iOS-VML-Player.git", :tag => "#{spec.version}" }

  spec.source_files  = "VMLPlayerController/VMLPlayerViewController.swift"
  # spec.exclude_files = "Classes/Exclude"
  # spec.public_header_files = "Classes/**/*.h"

  spec.resources  = [
    "VMLPlayerController/bundle.js",
    "VMLPlayerController/main.css",
    "VMLPlayerController/index.html",
    "VMLPlayerController/VMLPlayerViewController.xib"
  ]

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"

end
