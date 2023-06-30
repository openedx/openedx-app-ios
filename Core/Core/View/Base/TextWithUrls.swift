//
//  TextWithUrls.swift
//  Core
//
//  Created by  Stepanok Ivan on 28.02.2023.
//

import SwiftUI

// swiftlint:disable shorthand_operator
public struct TextWithUrls: View {
    
    var message: String
    
    public init(_ message: String) {
        self.message = message.hideHtmlTags()
    }
    
    public var body: some View {
        attribute(string: message, color: .accentColor)
    }
    
    private func getMarkupText(url: String) -> String {
        let placeholderText = "[\(url)]"
        var hyperlink: String
            if url.hasPrefix("https://www.") {
                hyperlink = "(\(url.replacingOccurrences(of: "https://www.", with: "https://")))"
            } else if url.hasPrefix("https:") {
                hyperlink = "(\(url))"
            } else if url.hasPrefix("http://www.") {
                hyperlink = "(\(url.replacingOccurrences(of: "http://www.", with: "http://")))"
            } else if url.hasPrefix("http:") {
                hyperlink = "(\(url))"
            } else if url.hasPrefix("www.") {
                hyperlink = "(\(url.replacingOccurrences(of: "www.", with: "https://")))"
            } else {
                hyperlink = "(http://\(url))"
            }
        
        return placeholderText + hyperlink
    }

    private func attribute(string: String, color: Color) -> Text {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        else {
            return Text(string)
        }

        let stringRange = NSRange(location: 0, length: string.count)

        let matches = detector.matches(
            in: string,
            options: [],
            range: stringRange
        )

        let attributedString = NSMutableAttributedString(string: string)
        for match in matches {
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single, range: match.range)
        }

        var text = Text("")
        attributedString.enumerateAttributes(in: stringRange, options: []) { attrs, range, _ in
            let valueOfString: String = attributedString.attributedSubstring(from: range).string
            text = text + Text(.init((attrs[.underlineStyle] != nil
                                      ? getMarkupText(url: valueOfString)
                                      : valueOfString)))
        }

        return text
    }
}
// swiftlint:enable shorthand_operator

struct TextWithUrls_Previews: PreviewProvider {
    static var previews: some View {
        TextWithUrls("clickable link here: http://google.com")
    }
}
