//
//  HTMLContentView.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 3.04.2025.
//

import SwiftUI
import Core
import Kingfisher
import Theme

// Custom callbacks for HTML conversion
struct CustomHTMLCallbacks: HTMLConversionCallbacks {
    static func makeURL(string: String) -> URL? {
        // Handle URL creation from string
        return URL(string: string)
    }
}

enum HTMLContentItem: Identifiable {
    case text(AttributedString)
    case image(HTMLImage)
    case blockquote(AttributedString)
    
    var id: UUID {
        switch self {
        case .text:
            return UUID()
        case .image(let img):
            return img.id
        case .blockquote:
            return UUID()
        }
    }
}

// Custom blockquote view with a left border
struct BlockquoteView: View {
    let text: AttributedString
    let textColor: Color
    
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 4)
            Text(text)
                .foregroundColor(textColor)
                .padding(.leading, 10)
                .tint(Color(uiColor: Theme.UIColors.accentColor))
        }
        .fixedSize(horizontal: false, vertical: true)
        .textSelection(.enabled)
    }
}

public struct HTMLContentView: View {
    private let html: String
    private let textColor: Color
    
    private var contentItems: [HTMLContentItem] = []
    
    public init(html: String, textColor: Color) {
        self.html = html
        self.textColor = textColor
        
        parseHTMLContent()
    }
    
    private mutating func parseHTMLContent() {
        // Pre-process HTML to fix problems with nested lists
        let htmlProcessor = HTMLContentFixProcessor()
        let fixedHTML = htmlProcessor.fixListStructure(html)
        
        // Extract all img tags and their positions in the text
        do {
            // Regular expression to search for img and blockquotes tags
            let imgPattern = #"(<img[^>]*>(?:</img>)?)"#
            let regex = try NSRegularExpression(pattern: imgPattern)
            let range = NSRange(fixedHTML.startIndex..<fixedHTML.endIndex, in: fixedHTML)
            let matches = regex.matches(in: fixedHTML, range: range)
            
            // If there are no images, we use a separate method to handle text content with blockquote
            if matches.isEmpty {
                parseTextWithBlockquotes(html: fixedHTML)
                return
            }
            
            // Split HTML into text and image segments
            var lastEndIndex = fixedHTML.startIndex
            
            for match in matches {
                let matchRange = Range(match.range, in: fixedHTML)!
                let imgTag = String(fixedHTML[matchRange])
                
                // If there is text before the img tag, add it
                if lastEndIndex < matchRange.lowerBound {
                    let textBefore = String(fixedHTML[lastEndIndex..<matchRange.lowerBound])
                    if !textBefore.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        parseTextWithBlockquotes(html: textBefore)
                    }
                }
                
                // Add an image
                if let image = extractImage(from: imgTag) {
                    contentItems.append(.image(image))
                }
                
                lastEndIndex = matchRange.upperBound
            }
            
            // If there is text after the last image, add it
            if lastEndIndex < fixedHTML.endIndex {
                let textAfter = String(fixedHTML[lastEndIndex..<fixedHTML.endIndex])
                if !textAfter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    parseTextWithBlockquotes(html: textAfter)
                }
            }
            
        } catch {
            print("Error parsing HTML content: \(error)")
            // If something went wrong, display all HTML as text
            contentItems.append(.text(convertHTMLToAttributedString(html: html)))
        }
    }
    
    // Parsing text and selecting blockquote elements
    private mutating func parseTextWithBlockquotes(html: String) {
        do {
            let blockquotePattern = #"<blockquote>(.*?)</blockquote>"#
            let blockquoteRegex = try NSRegularExpression(
                pattern: blockquotePattern,
                options: [.dotMatchesLineSeparators]
            )
            let range = NSRange(html.startIndex..<html.endIndex, in: html)
            let matches = blockquoteRegex.matches(in: html, range: range)
            
            // If there are no blockquotes, just add text as usual.
            if matches.isEmpty {
                contentItems.append(.text(convertHTMLToAttributedString(html: html)))
                return
            }
            
            // Split HTML into plain text and blockquotes
            var lastEndIndex = html.startIndex
            
            for match in matches {
                let matchRange = Range(match.range, in: html)!
                let blockquoteRange = Range(match.range(at: 1), in: html)!
                
                // If there is text before the blockquote, add it
                if lastEndIndex < matchRange.lowerBound {
                    let textBefore = String(html[lastEndIndex..<matchRange.lowerBound])
                    if !textBefore.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        contentItems.append(.text(convertHTMLToAttributedString(html: textBefore)))
                    }
                }
                
                // Add blockquote
                let blockquoteContent = String(html[blockquoteRange])
                contentItems.append(.blockquote(convertHTMLToAttributedString(html: blockquoteContent)))
                
                lastEndIndex = matchRange.upperBound
            }
            
            // If there is text after the last blockquote, add it.
            if lastEndIndex < html.endIndex {
                let textAfter = String(html[lastEndIndex..<html.endIndex])
                if !textAfter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    contentItems.append(.text(convertHTMLToAttributedString(html: textAfter)))
                }
            }
        } catch {
            print("Error parsing blockquotes: \(error)")
            contentItems.append(.text(convertHTMLToAttributedString(html: html)))
        }
    }
    
    private func extractImage(from imgTag: String) -> HTMLImage? {
        do {
            let srcPattern = #"src=["']([^"']+)["']"#
            let altPattern = #"alt=["']([^"']*?)["']"#
            
            // Извлекаем URL изображения
            let srcRegex = try NSRegularExpression(pattern: srcPattern)
            let srcRange = NSRange(imgTag.startIndex..<imgTag.endIndex, in: imgTag)
            
            guard let srcMatch = srcRegex.firstMatch(in: imgTag, range: srcRange),
                  let urlRange = Range(srcMatch.range(at: 1), in: imgTag),
                  let url = URL(string: String(imgTag[urlRange])) else {
                return nil
            }
            
            // Extract alt text, if any
            var altText: String?
            let altRegex = try NSRegularExpression(pattern: altPattern)
            if let altMatch = altRegex.firstMatch(in: imgTag, range: srcRange),
               let altRange = Range(altMatch.range(at: 1), in: imgTag) {
                altText = String(imgTag[altRange])
            }
            
            return HTMLImage(url: url, altText: altText)
        } catch {
            print("Error extracting image from tag: \(error)")
            return nil
        }
    }
    
    private func convertHTMLToAttributedString(html: String) -> AttributedString {
        // Basic paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 8
        
        // Process the HTML to fix any issues 
        let htmlProcessor = HTMLContentFixProcessor()
        let processedHTML = htmlProcessor.fixListStructure(html)
        
        let converter = AttributedStringConverter<CustomHTMLCallbacks>(
            configuration: AttributedStringConverterConfiguration(
                font: .systemFont(ofSize: 16),
                monospaceFont: .monospacedSystemFont(ofSize: 16, weight: .regular),
                fontMetrics: .default,
                color: .label,
                paragraphStyle: paragraphStyle
            )
        )
        
        // The link styling will be handled in the AttributedStringConverter
        return AttributedString(converter.convert(html: processedHTML))
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(contentItems) { item in
                switch item {
                case .text(let attributedText):
                    Text(attributedText)
                        .foregroundColor(textColor)
                        .fixedSize(horizontal: false, vertical: true)
                        .textSelection(.enabled)
                        .tint(Color(uiColor: Theme.UIColors.accentColor))
                case .image(let image):
                    HTMLImageView(image: image)
                        .padding(.vertical, 8)
                case .blockquote(let blockquoteText):
                    BlockquoteView(text: blockquoteText, textColor: textColor)
                        .padding(.vertical, 4)
                }
            }
        }
    }
}
