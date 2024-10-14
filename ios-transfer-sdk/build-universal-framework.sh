# Taken from https://medium.com/onfido-tech/distributing-compiled-swift-frameworks-via-cocoapods-8cb67a584d57
# create folder where we place built frameworks
mkdir build
# build framework for simulators
xcodebuild clean build   -project ConnectTransfer.xcodeproj   -scheme ConnectTransfer   -configuration Release   -sdk iphonesimulator   -derivedDataPath derived_data -xcconfig Config.xcconfig
# create folder to store compiled framework for simulator
mkdir build/simulator
# copy compiled framework for simulator into our build folder
cp -r derived_data/Build/Products/Release-iphonesimulator/ConnectTransfer.framework build/simulator
#build framework for devices
xcodebuild clean build   -project ConnectTransfer.xcodeproj   -scheme ConnectTransfer   -configuration Release   -sdk iphoneos   -derivedDataPath derived_data -xcconfig Config.xcconfig
# create folder to store compiled framework for simulator
mkdir build/devices
# copy compiled framework for simulator into our build folder
cp -r derived_data/Build/Products/Release-iphoneos/ConnectTransfer.framework build/devices
# create folder to store compiled universal framework
mkdir build/universal
####################### Create universal framework #############################
# copy device framework into universal folder
cp -r build/devices/ConnectTransfer.framework build/universal/
# create framework binary compatible with simulators and devices, and replace binary in universal framework
lipo -create   build/simulator/ConnectTransfer.framework/ConnectTransfer   build/devices/ConnectTransfer.framework/ConnectTransfer   -output build/universal/ConnectTransfer.framework/ConnectTransfer
# copy simulator Swift public interface to universal framework
cp build/simulator/ConnectTransfer.framework/Modules/ConnectTransfer.swiftmodule/* build/universal/ConnectTransfer.framework/Modules/ConnectTransfer.swiftmodule
