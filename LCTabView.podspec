Pod::Spec.new do |spec|

  spec.name           = "LCTabView"

  spec.version        = "1.0.0"
  
  spec.summary        = "LCTabView is a Cocoa framework that supports customizing the background color of the selected item in TabView."

  spec.description    = <<-DESC
LCTabView is a Cocoa framework that supports customizing the background color of the selected item in TabView. No longer limited to the default dimmed style!
                      DESC

  spec.homepage       = "https://github.com/DevLiuSir/LCTabView"
  
  spec.license        = { :type => "MIT", :file => "LICENSE" }
  
  spec.author         = { "Marvin" => "93428739@qq.com" }

  spec.swift_versions = ['5.0']
  
  spec.platform       = :osx

  spec.osx.deployment_target = "10.14"

  spec.source       = { :git => "https://github.com/DevLiuSir/LCTabView.git", :tag => "#{spec.version}" }

  spec.source_files   = "Sources/LCTabView/**/*.{h,m,swift}"

end
