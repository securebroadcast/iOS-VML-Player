#
#  Be sure to run `pod spec lint VMLPlayerController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "VMLPlayerController"
  spec.version      = "0.0.1"
  spec.summary      = "VMLPlayerController"

  spec.homepage     = "https://github.com/securebroadcast/iOS-VML-Player"

  spec.authors      = "Jordan Carroll", "Kris Jones", "Frazer Robinson"
  spec.license      = "MIT"

  spec.platform     = :ios, "12.0"

  spec.source       = { :git => "https://github.com/securebroadcast/iOS-VML-Player.git", :tag => "#{spec.version}" }

  spec.source_files  = "VMLPlayerController/VMLPlayerViewController.swift"
  # spec.exclude_files = "Classes/Exclude"
  # spec.public_header_files = "Classes/**/*.h"

  spec.resource  = "bundle.js"
  spec.resource  = "main.css"
  spec.resource  = "index.html"
  spec.resource  = "VMLPlayerViewController.xib"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"

end
