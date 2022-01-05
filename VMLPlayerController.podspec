Pod::Spec.new do |spec|

  spec.name         = "VMLPlayerController"
  spec.version      = "1.0.1"
  spec.summary      = "VMLPlayerController"

  spec.homepage     = "https://github.com/securebroadcast/iOS-VML-Player"

  spec.authors      = "Jordan Carroll", "Kris Jones", "Frazer Robinson", "Chris McClune"
  spec.license      = "MIT"

  spec.platform     = :ios, "12.1"
  spec.swift_version = "5.0"

  spec.source       = { :git => "https://github.com/securebroadcast/iOS-VML-Player.git", :tag => "#{spec.version}" }

  spec.source_files  = "VMLPlayerController/VMLPlayerViewController.swift"

  spec.resources  = [
    "VMLPlayerController/bundle.js",
    "VMLPlayerController/main.css",
    "VMLPlayerController/index.html",
    "VMLPlayerController/VMLPlayerViewController.xib"
  ]

end
