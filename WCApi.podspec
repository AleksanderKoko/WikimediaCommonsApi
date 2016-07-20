#
# Be sure to run `pod lib lint WCApi.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WCApi'
  s.version          = '0.1.2'
  s.summary          = 'WCApi is a simple package that makes working with Wikimedia Commons API simpler'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Wikimedia Commons API is really difficult to work with. API is changing all the time, many endpoints are not intuitive, for some simple calls they require up to 3-4 calls. This package makes some calls simple to use.
                       DESC

  s.homepage         = 'https://github.com/AleksanderKoko/WikimediaCommonsApi'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Aleksander Koko' => 'aleksanderkoko@gmail.com' }
  s.source           = { :git => 'https://github.com/AleksanderKoko/WikimediaCommonsApi.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WCApi/Classes/**/*'

  # s.resource_bundles = {
  #   'WCApi' => ['WCApi/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Alamofire', '~> 3.4'
#s.dependency 'RealmSwift'
end
