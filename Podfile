# platform :ios, '12.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'garbageCollection' do
  use_frameworks!

  # Core
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'RxDataSources', '~> 4.0'
  pod 'RxBiBinding'
  pod 'Parse'
  
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'

  # Layout
  pod 'SnapKit', '~> 5.0.0'
  
  # UI
  pod 'SVProgressHUD'
  pod 'NotificationBannerSwift', '~> 3.0.0'

  target 'garbageCollectionTests' do
    inherit! :search_paths
  end

  target 'garbageCollectionUITests' do
    inherit! :search_paths
  end
  
  target 'ColetaUISnapshot' do
    inherit! :search_paths
  end

end
