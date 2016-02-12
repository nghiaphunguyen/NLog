Pod::Spec.new do |s|
  s.name         = "NLog"
  s.version      = "0.1"
  s.summary      = ""
  s.homepage     = ""
  s.license      = "MIT"
  s.author       = "Nghia Nguyen"
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://bitbucket.org/nghiaphunguyen/nlog", :tag => s.version}
  s.source_files  = "Classes", "NLog/NLog/**/*.{swift}"
  s.requires_arc = true

  s.dependency 'RealmSwift'
end