Pod::Spec.new do |spec|  
  spec.name         = "MastercardOpenBankingConnectTransfer"
  spec.module_name  = "ConnectTransfer"
  spec.version      = "1.0.0"
  spec.summary      = "Connect Transfer iOS SDK"
  spec.description  = <<-DESC
                      The ConnectTransfer iOS SDK allows you to embed MastercardOpenBanking ConnectTransfer anywhere you want within your own mobile applications.
                      DESC
  spec.homepage     = "https://developer.mastercard.com/open-banking-us/documentation/connect/integrating/"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = "MastercardOpenBanking"
  spec.platform     = :ios, "14.0"
  spec.source       = { :git => "https://github.com/Mastercard/connect-ios-sdk.git", :tag => "#{spec.version}" }
  spec.ios.vendored_frameworks = "ConnectTransfer.xcframework"
  # spec.resource_bundles = {'MastercardOpenBankingConnectTransfer' => ['Source/*.xcprivacy']}
  spec.dependency "AtomicSDK", "3.5.20"
end
