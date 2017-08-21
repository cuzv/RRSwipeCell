Pod::Spec.new do |s|
  s.name         = "RRSwipeCell"
  s.version      = "0.1.1"
  s.summary      = "Swipeable UICollectionViewCell"

  s.homepage     = "https://github.com/cuzv/RRSwipeCell"
  s.license      = "MIT"
  s.author       = { "Moch Xiao" => "cuzval@gmail.com" }
  s.platform     = :ios, "7.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/cuzv/RRSwipeCell.git",
:tag => s.version.to_s }
  s.source_files = "Sources/*.{h,m}"
  s.frameworks   = 'Foundation', 'UIKit'
end

