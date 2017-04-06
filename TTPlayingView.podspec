Pod::Spec.new do |s|

  s.name         = "TTPlayingView"
  s.version      = "1.0.0"
  s.summary      = "A simple playing animation view."

  s.description  = <<-DESC
                    A simple playing animation view.
                   DESC

  s.homepage     = "https://github.com/edisongz/TTPlayingView"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "jiang" => "edisongz123@gmail.com" }
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"

  s.source       = { :git => "https://github.com/edisongz/TTPlayingView.git", :tag => "1.0.0" }

  s.source_files = 'TTPlayingView/*.{h,m}'
  s.public_header_files = 'TTPlayingView/*.{h}'

  s.frameworks = "UIKit", "Foundation", "QuartzCore"
  s.requires_arc = true

end
