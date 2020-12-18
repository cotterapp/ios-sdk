# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

target 'Cotter' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Cotter
  pod 'TTGSnackbar', '1.10.3'
  pod 'OneSignal', '~> 3.0'
  
  target 'CotterTests' do
    inherit! :search_paths
    pod 'TTGSnackbar', '1.10.3'
    pod 'Nimble', '~> 8.0'
    pod 'Sourcery'
  end

  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
