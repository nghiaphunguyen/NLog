Pod::Spec.new do |s|
  s.name         = "NLog"
  s.version      = "1.2.3"
  s.summary      = "NLog is wrapper of print function"
  s.homepage     = "http://knacker.com"
  s.license      = "MIT"
  s.author       = "Nghia Nguyen"
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/nghiaphunguyen/NLog.git", :tag => s.version}
  s.source_files  = "Classes", "NLog/NLog/**/*.{swift}"
  s.requires_arc = true
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

  s.dependency 'RealmSwift', '1.1.0'
  s.dependency 'Realm', '1.1.0'
end
