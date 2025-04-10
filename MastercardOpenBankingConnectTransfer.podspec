Pod::Spec.new do |spec|  
  spec.name         = "MastercardOpenBankingConnectTransfer"
  spec.module_name  = "ConnectTransfer"
  spec.version      = "1.2.0"
  spec.summary      = "Connect Transfer iOS SDK"
  spec.description  = <<-DESC
                      The Connect Transfer iOS SDK allows you to embed MastercardOpenBanking Connect Transfer anywhere you want within your own mobile applications.
                      DESC
  spec.homepage     = "https://developer.mastercard.com/open-banking-us/documentation/products/pay/deposit-switch/#using-the-connect-transfer-ios-and-android-sdks"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = "MastercardOpenBanking"
  spec.platform     = :ios, "14.0"
  spec.source       = { :git => "https://github.com/Mastercard/connect-transfer-ios-sdk.git", :tag => "#{spec.version}" }
  spec.ios.vendored_frameworks = "ConnectTransfer.xcframework"
  spec.resource_bundles = {'MastercardOpenBankingConnectTransfer' => ['Sources/*.xcprivacy']}
  spec.dependency "AtomicSDK", "3.9.23"
end
