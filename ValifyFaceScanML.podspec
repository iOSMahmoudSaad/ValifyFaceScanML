Pod::Spec.new do |spec|
  spec.name         = "ValifyFaceScanML"
  spec.version      = "1.0.1"
  spec.summary      = "Face detection using ValifyFaceScanML."
  spec.description  = "This framework allows you to verify your identity by taking a selfie using the camera."
  spec.homepage     = "https://github.com/iOSMahmoudSaad/ValifyFaceScanML"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { "Mahmoud Saad" => "msaaad202020@gmail.com" }
  spec.source       = { :git => "https://github.com/iOSMahmoudSaad/ValifyFaceScanML.git", :tag => "#{spec.version}" }
  spec.platform     = :ios, "13.0"
  spec.swift_version = '5.0'
  spec.source_files  = "ValifyFaceScanML/**/*.{swift,xib}"
  spec.frameworks   = "UIKit"
end
