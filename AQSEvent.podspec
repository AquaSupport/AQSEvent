Pod::Spec.new do |s|
  s.name         = "AQSEvent"
  s.version      = "0.1.0"
  s.summary      = "[iOS] A helper for Measurement Events"
  s.homepage     = "https://github.com/AquaSupport/AQSEvent"
  s.license      = "MIT"
  s.author       = { "kaiinui" => "lied.der.optik@gmail.com" }
  s.source       = { :git => "https://github.com/AquaSupport/AQSEvent.git", :tag => "v0.1.0" }
  s.source_files  = "AQSEvent/Classes/**/*.{h,m}"
  s.requires_arc = true
  s.platform = "ios", '7.0'
end
