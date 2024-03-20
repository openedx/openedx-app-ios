//
//  HandoutsAnnouncementsDetailView.swift
//  Course
//
//  Created by  Stepanok Ivan on 27.02.2023.
//

import SwiftUI
import Core
import Theme

public struct HandoutsUpdatesDetailView: View {
    
    @Environment(\.colorScheme) var colorSchemeNative
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @State var colorScheme: ColorScheme = UITraitCollection.current.userInterfaceStyle == .light ? .light : .dark
    
    private var router: CourseRouter
    private let cssInjector: CSSInjector
    private var handouts: String?
    private var announcements: [CourseUpdate]?
    private let title: String
    
    public init(
        handouts: String?,
        announcements: [CourseUpdate]?,
        router: CourseRouter,
        cssInjector: CSSInjector
    ) {
        let noHandouts = handouts == nil && announcements == nil
        
        if announcements == nil {
            self.title = CourseLocalization.HandoutsCellHandouts.title
        } else {
            self.title = CourseLocalization.HandoutsCellAnnouncements.title
        }
        
        self.handouts = noHandouts ? CourseLocalization.Error.noHandouts : handouts
        self.announcements = announcements
        self.router = router
        self.cssInjector = cssInjector
    }
    
    private func updateColorScheme() {
        colorScheme = UITraitCollection.current.userInterfaceStyle == .light ? .light : .dark
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
            Theme.Colors.background
                .ignoresSafeArea()
                // MARK: - Page Body
                VStack(alignment: .leading) {
                    // MARK: - Handouts
                    if let handouts {
                        let formattedHandouts = cssInjector.injectCSS(
                            colorScheme: colorScheme,
                            html: handouts,
                            type: .discovery,
                            fontSize: idiom == .pad ? 100 : 300,
                            screenWidth: .infinity
                        )
                        
                        WebViewHtml(fixBrokenLinks(in: formattedHandouts))
                    } else if let html = announcemetsHtml() {
                        // MARK: - Announcements
                        WebViewHtml(fixBrokenLinks(in: html))
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal, 32)
                .frame(
                    maxHeight: .infinity,
                    alignment: .topLeading)
                .onRightSwipeGesture {
                    router.back()
                }
                Spacer(minLength: 84)
        }
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(false)
        .navigationTitle(title)
        .onChange(of: colorSchemeNative) { _ in
            guard UIApplication.shared.applicationState == .active else { return }
            updateColorScheme()
        }
    }
    
    func fontsCSS(for fontFamily: String) -> String? {
        if let path = Bundle(for: ThemeBundle.self).path(forResource: "fonts_file", ofType: "ttf"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            let fontCSS = """
            @font-face {
                font-family: \(fontFamily);
                src: url(data:font/truetype;charset=utf-8;base64,\(data.base64EncodedString())) format('truetype');
                font-weight: normal;
                font-style: normal;
            }
            """
            return "<style>\(fontCSS)</style>"
        }
        return nil
    }
    
    func titleHTML(fontFamily: String, fontSize: CGFloat, title: String) -> String {
        """
            <center>
                <p style = "
                    font-family: \(fontFamily) !important;
                    color: inherit !important;
                    font-weight: normal !important;
                    font-size: \(fontSize)px !important;
                    padding: 0 !important;
                    margin-top: 0px !important;
                ">
                    \(title)
                </p>
            </center>
        """
    }
    
    func dividerHTML() -> String {
        """
            <div style="
                margin-top: 3px !important;
                margin-bottom: 3px !important;
                background-color: \(UIColor.opaqueSeparator.cgColor.hexString ?? "") !important;
                width: 100%;
                height: 0.5px;
            ">
            </div>
        """
    }
    
    func announcemetsHtml() -> String? {
        guard let announcements = announcements else {return nil}
        var html: String = ""
        let font = Theme.UIFonts.labelSmall()
        let fontFamily = font.familyName
        let fontSize = font.pointSize
        
        if let fontsCSS = fontsCSS(for: fontFamily) {
            html.append(fontsCSS)
        }

        for (index, ann) in announcements.enumerated() {
            let titleHTML = titleHTML(fontFamily: fontFamily, fontSize: fontSize, title: ann.date)
            html.append("<div>\(titleHTML)\n\(ann.content)</div>")
            
            if index != announcements.count - 1 {
                html.append(dividerHTML())
            }
        }
        let formattedAnnouncements = cssInjector.injectCSS(
            colorScheme: colorScheme,
            html: html,
            type: .discovery,
            fontSize: 100,
            screenWidth: .infinity
        )

        return """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1" />
            </head>
            <body>
                \(formattedAnnouncements)
            </body>
        </html>
        """
    }
}

#if DEBUG
// swiftlint:disable all
struct HandoutsUpdatesDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let handouts = """
Hi! Welcome to the demonstration course. We built this to help you become more familiar with taking a course on this site prior to your first day of class. \n<br>\n<br>\nIn a live course, this section is where all of the latest course announcements and updates would be. To get started with this demo course, view the \n\n\n\n<a href=\"/courses/course-v1:ios+1+2023/courseware/d8a6192ade314473a78242dfeedfbf5b/edx_introduction/\">courseware page</a> and click &#8220;Example Week 1&#8221; in the left hand navigation.  \n\n\n\n\n<br>\n<br>\nWe tried to make this both fun and informative. We hope you like it. At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.\n\n\n
"""
        
        let loremIpsumHtml = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollitia animi, id est laborum.
"""
        
        HandoutsUpdatesDetailView(
            handouts: nil,
            announcements: [
                CourseUpdate(
                    id: 1,
                    date: "1 march",
                    content: handouts,
                    status: "done"
                ),
                CourseUpdate(
                    id: 2,
                    date: "3 april",
                    content: loremIpsumHtml,
                    status: "nice")],
            router: CourseRouterMock(),
            cssInjector: CSSInjectorMock()
        )
    }
}
// swiftlint:enable all
#endif
