# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
use_frameworks!



def shared_pods
    pod 'SnapKit', '~> 5.0.1'
    pod 'RxSwift', '~> 5.0.1'
    pod 'RxCocoa', '~> 5.0.1'
end

target 'MallAR' do
    shared_pods
end

#target 'IranMall Staging' do
#    shared_pods
#end

target 'MallARTests' do
  inherit! :search_paths
end

#post_install do |installer|
#    installer.pods_project.build_configurations.each do |config|
#        config.build_settings.delete('CODE_SIGNING_ALLOWED')
#        config.build_settings.delete('CODE_SIGNING_REQUIRED')
#    end
#end
