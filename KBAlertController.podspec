#
#  Be sure to run `pod spec lint KBFormSheetController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "KBAlertController"
  s.version      = "0.0.3"
  s.summary      = "KBAlertController."
  s.author       = {"xiaoxiong" => "821859554@qq.com"}
  s.description  = <<-DESC
                    This is KBAlertController.
                   DESC

  s.homepage     = "ssh://git@121.41.38.122:2020/kuaibao/gitdata/iOS/KBAlertController.git"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "ssh://git@121.41.38.122:2020/kuaibao/gitdata/iOS/KBAlertController.git", :tag => s.version.to_s }

  s.source_files  = "KBAlertController/KBAlertController/**/*.{h,m}"
  #s.frameworks = "CoreGraphics", "UIKit"
  s.requires_arc = true
  s.dependency "KBFormSheetController"


end
