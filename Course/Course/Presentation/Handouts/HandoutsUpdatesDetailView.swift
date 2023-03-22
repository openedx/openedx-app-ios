//
//  HandoutsAnnouncementsDetailView.swift
//  Course
//
//  Created by  Stepanok Ivan on 27.02.2023.
//

import SwiftUI
import Core

public struct HandoutsUpdatesDetailView: View {
    
    @Environment(\.colorScheme) var colorScheme
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    private var router: CourseRouter
    private let cssInjector: CSSInjector
    private var handouts: String?
    private var announcements: [CourseUpdate]?
    private let title: String
    
    public init(handouts: String?, announcements: [CourseUpdate]?, router: CourseRouter, cssInjector: CSSInjector) {
        if handouts != nil {
            self.title = CourseLocalization.HandoutsCellHandouts.title
        } else {
            self.title = CourseLocalization.HandoutsCellAnnouncements.title
        }
        self.handouts = handouts
        self.announcements = announcements
        self.router = router
        self.cssInjector = cssInjector
    }
    
    private func fixBrokenLinks(in htmlString: String) -> String {
        do {
            let regex = try NSRegularExpression(
                pattern: "<a[^>]*href=[\"'](?<url>.*?)[\"'][^>]*>(?<text>.*?)</a>"
            )
            let range = NSRange(location: 0, length: htmlString.utf16.count)
            let matches = regex.matches(in: htmlString, options: [], range: range)
            
            var updatedHtmlString = htmlString
            for match in matches {
                guard let urlRange = Range(match.range(withName: "url"), in: htmlString)
                else {
                    continue
                }
                
                let url = String(htmlString[urlRange])
                if !url.contains("http") {
                    let fixedUrl = "http://" + url
                    updatedHtmlString = updatedHtmlString.replacingOccurrences(of: url, with: fixedUrl)
                }
            }
            
            return updatedHtmlString
        } catch {
            print("Error fixing broken links: \(error)")
            return htmlString
        }
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { reader in
                // MARK: - Page name
                VStack(alignment: .center) {
                    NavigationBar(title: title,
                                  leftButtonAction: { router.back() })
                    
                    // MARK: - Page Body
                    VStack(alignment: .leading) {
                        if let handouts {
                            let formattedHandouts = cssInjector.injectCSS(colorScheme: colorScheme,
                                                                          html: handouts,
                                                                          type: .discovery,
                                                                          fontSize: idiom == .pad ? 100 : 300,
                                                                          screenWidth: .infinity)
                            
                            WebViewHtml(fixBrokenLinks(in: formattedHandouts))
                        } else if let announcements {
                            ScrollView {
                                ForEach(Array(announcements.enumerated()), id: \.offset) { index, ann in
                                    
                                    Text(ann.date)
                                        .font(Theme.Fonts.labelSmall)
                                    let formattedAnnouncements = cssInjector.injectCSS(colorScheme: colorScheme,
                                                                                       html: ann.content,
                                                                                       type: .discovery,
                                                                                       screenWidth: reader.size.width)
                                    HTMLFormattedText(fixBrokenLinks(in: formattedAnnouncements))
                                    
                                    if index != announcements.count - 1 {
                                        Divider()
                                    }
                                }
                            }.frame(minWidth: 0,
                                    maxWidth: .infinity,
                                    minHeight: 0,
                                    maxHeight: .infinity)
                        }
                    }.padding(.horizontal, 32)
                        .frame(
                            maxHeight: .infinity,
                            alignment: .topLeading)
                        .onRightSwipeGesture {
                            router.back()
                        }
                    Spacer(minLength: 84)
                    
                }.background(
                    CoreAssets.background.swiftUIColor
                        .ignoresSafeArea()
                )
            }
            
        }
    }
}

#if DEBUG
struct HandoutsUpdatesDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        var handouts = """
<style>
@font-face {
  font-family: "San Francisco";
  font-weight: 400;
  src: url("https://applesocial.s3.amazonaws.com/assets//fonts/sanfrancisco/sanfranciscodisplay-regular-webfont.woff");
}
.header {
font-size: 150%;
font-family: -apple-system, system-ui, BlinkMacSystemFont;
  background-color: clear;
  color: black;
max-width: infpx;
}
img {max-width: infpx;
  width: auto;
  height: auto;
}
</style>
<table class="header">
<tr>
<td><h3>Essential Documents:</h3>
<ul style="list-style-type: disc; font-size: 1.1em;">
<li><a title="Download Syllabus PDF"
href="google.com"
target="_blank">Certificate Syllabus</a></li>
<li><a title="Download UW Start Learning Guide PDF" href="facebook.com">Learning Platform Guide</a></li>

  <div style="background-color: #ffeed2; margin: 30px; padding: 30px; border: thin solid black;"><p><span class="fa
fa-warning" title="warning icon">&nbsp;</span> <span class="sr">warning Icon</span> This is a reminder that the University
of Washington is requiring all students, including students enrolled in fully online programs, to be vaccinated against
COVID-19 or declare an exemption by <strong>September 29, 2021</strong>.<p>You can verify your vaccination status or claim
an exemption through a <a href="https://www.washington.edu/coronavirus/vaccination-requirement/">secure vaccination
attestation form</a>. You must submit the form by <strong>November 5, 2021</strong>, or there will be a hold placed
on your account preventing you from registering for your next course.</p></div>
<hr style="border-bottom: thin solid #ddd;" title="Next announcement"
"""
        
        HandoutsUpdatesDetailView(handouts: handouts,
                                  announcements: [],
                                  router: CourseRouterMock(),
                                  cssInjector: CSSInjectorMock())
    }
}
#endif
