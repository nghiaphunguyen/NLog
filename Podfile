# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'NLog' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
pod 'RealmSwift'
pod 'NLogProtocol'
  # Pods for NLog

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'

            if config.name == 'Debug'
                config.build_settings['OTHER_SWIFT_FLAGS'] = '-DDEBUG'
                else
                config.build_settings['OTHER_SWIFT_FLAGS'] = ''
            end
        end
    end
end
