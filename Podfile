platform :ios, '16.0'
use_frameworks! :linkage => :static

abstract_target "App" do
  
  #Code style
  pod 'SwiftLint', '~> 0.57.0'
  #CodeGen for resources
  pod 'SwiftGen', '~> 6.6'
  
  target "OpenEdX" do
    inherit! :complete
    workspace './OpenEdX.xcodeproj'
  end
  
  target "Core" do
    project './Core/Core.xcodeproj'
    workspace './Core/Core.xcodeproj'

    target 'CoreTests' do
      pod 'SwiftyMocky', :git => 'https://github.com/MakeAWishFoundation/SwiftyMocky.git', :tag => '4.2.0'
    end
  end
  
  target "Authorization" do
    project './Authorization/Authorization.xcodeproj'
    workspace './Authorization/Authorization.xcodeproj'
    
    target 'AuthorizationTests' do
      pod 'SwiftyMocky', :git => 'https://github.com/MakeAWishFoundation/SwiftyMocky.git', :tag => '4.2.0'
    end
  end
  
  target "Discovery" do
    project './Discovery/Discovery.xcodeproj'
    workspace './Discovery/Discovery.xcodeproj'
    
    target 'DiscoveryUnitTests' do
      pod 'SwiftyMocky', :git => 'https://github.com/MakeAWishFoundation/SwiftyMocky.git', :tag => '4.2.0'
    end
  end
  
  target "WhatsNew" do
    project './WhatsNew/WhatsNew.xcodeproj'
    workspace './WhatsNew/WhatsNew.xcodeproj'
    
    target 'WhatsNewTests' do
      pod 'SwiftyMocky', :git => 'https://github.com/MakeAWishFoundation/SwiftyMocky.git', :tag => '4.2.0'
    end
  end
  
  target "Dashboard" do
    project './Dashboard/Dashboard.xcodeproj'
    workspace './Dashboard/Dashboard.xcodeproj'
    
    target 'DashboardTests' do
      pod 'SwiftyMocky', :git => 'https://github.com/MakeAWishFoundation/SwiftyMocky.git', :tag => '4.2.0'
    end
  end
  
  target "Profile" do
    project './Profile/Profile.xcodeproj'
    workspace './Profile/Profile.xcodeproj'
    
    target 'ProfileTests' do
      pod 'SwiftyMocky', :git => 'https://github.com/MakeAWishFoundation/SwiftyMocky.git', :tag => '4.2.0'
    end
  end
  
  target "Course" do
    project './Course/Course.xcodeproj'
    workspace './Course/Course.xcodeproj'
    
    target 'CourseTests' do
      pod 'SwiftyMocky', :git => 'https://github.com/MakeAWishFoundation/SwiftyMocky.git', :tag => '4.2.0'
    end
  end
  
  target "Discussion" do
    project './Discussion/Discussion.xcodeproj'
    workspace './Discussion/Discussion.xcodeproj'
    
    target 'DiscussionTests' do
      pod 'SwiftyMocky', :git => 'https://github.com/MakeAWishFoundation/SwiftyMocky.git', :tag => '4.2.0'
    end
  end
  
  target "Theme" do
    project './Theme/Theme.xcodeproj'
    workspace './Theme/Theme.xcodeproj'
    
    target 'ThemeTests' do
      pod 'SwiftyMocky', :git => 'https://github.com/MakeAWishFoundation/SwiftyMocky.git', :tag => '4.2.0'
    end
  end
  
end
