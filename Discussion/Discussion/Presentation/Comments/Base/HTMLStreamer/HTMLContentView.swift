import SwiftUI
import Core
import Kingfisher
import Theme

//swiftlint: disable all
// Custom callbacks for HTML conversion
struct CustomHTMLCallbacks: HTMLConversionCallbacks {
    static func makeURL(string: String) -> URL? {
        // Handle URL creation from string
        return URL(string: string)
    }
}

// Тип контента HTML - может быть текстом или изображением
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
        // Предварительно обрабатываем HTML для исправления проблем со вложенными списками
        let fixedHTML = fixNestedLists(html)
        
        // Извлекаем все теги img и их позиции в тексте
        do {
            // Регулярное выражение для поиска тегов img и blockquotes
            let imgPattern = #"(<img[^>]*>(?:</img>)?)"#
            let regex = try NSRegularExpression(pattern: imgPattern)
            let range = NSRange(fixedHTML.startIndex..<fixedHTML.endIndex, in: fixedHTML)
            let matches = regex.matches(in: fixedHTML, range: range)
            
            // Если изображений нет, используем отдельный метод для обработки текстового содержимого с blockquote
            if matches.isEmpty {
                parseTextWithBlockquotes(html: fixedHTML)
                return
            }
            
            // Разбиваем HTML на сегменты текста и изображений
            var lastEndIndex = fixedHTML.startIndex
            
            for match in matches {
                let matchRange = Range(match.range, in: fixedHTML)!
                let imgTag = String(fixedHTML[matchRange])
                
                // Если перед тегом img есть текст, добавляем его
                if lastEndIndex < matchRange.lowerBound {
                    let textBefore = String(fixedHTML[lastEndIndex..<matchRange.lowerBound])
                    if !textBefore.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        parseTextWithBlockquotes(html: textBefore)
                    }
                }
                
                // Добавляем изображение
                if let image = extractImage(from: imgTag) {
                    contentItems.append(.image(image))
                }
                
                lastEndIndex = matchRange.upperBound
            }
            
            // Если после последнего изображения есть текст, добавляем его
            if lastEndIndex < fixedHTML.endIndex {
                let textAfter = String(fixedHTML[lastEndIndex..<fixedHTML.endIndex])
                if !textAfter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    parseTextWithBlockquotes(html: textAfter)
                }
            }
            
        } catch {
            print("Error parsing HTML content: \(error)")
            // Если что-то пошло не так, отображаем весь HTML как текст
            contentItems.append(.text(convertHTMLToAttributedString(html: fixNestedLists(html))))
        }
    }
    
    // Парсим текст и выделяем blockquote элементы
    private mutating func parseTextWithBlockquotes(html: String) {
        do {
            // Поищем blockquote теги
            let blockquotePattern = #"<blockquote>(.*?)</blockquote>"#
            let blockquoteRegex = try NSRegularExpression(
                pattern: blockquotePattern,
                options: [.dotMatchesLineSeparators]
            )
            let range = NSRange(html.startIndex..<html.endIndex, in: html)
            let matches = blockquoteRegex.matches(in: html, range: range)
            
            // Если blockquotes нет, просто добавляем текст как обычно
            if matches.isEmpty {
                contentItems.append(.text(convertHTMLToAttributedString(html: html)))
                return
            }
            
            // Разбиваем HTML на обычный текст и blockquotes
            var lastEndIndex = html.startIndex
            
            for match in matches {
                let matchRange = Range(match.range, in: html)!
                let blockquoteRange = Range(match.range(at: 1), in: html)!
                
                // Если перед blockquote есть текст, добавляем его
                if lastEndIndex < matchRange.lowerBound {
                    let textBefore = String(html[lastEndIndex..<matchRange.lowerBound])
                    if !textBefore.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        contentItems.append(.text(convertHTMLToAttributedString(html: textBefore)))
                    }
                }
                
                // Добавляем blockquote
                let blockquoteContent = String(html[blockquoteRange])
                contentItems.append(.blockquote(convertHTMLToAttributedString(html: blockquoteContent)))
                
                lastEndIndex = matchRange.upperBound
            }
            
            // Если после последнего blockquote есть текст, добавляем его
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
    
    // Исправляем проблемы с вложенными списками
    private func fixNestedLists(_ html: String) -> String {
        print(">>>DEB 🔄 fixNestedLists - START")
        print(">>>DEB Original HTML: \(html)")
        var processedHTML = html
        
        do {
            // First, let's fix any broken list structure
            // Add closing tags if missing
            var result = processedHTML
            
            // Find nesting patterns like <ul><ul> or <ol><ol> and add proper li elements
            let directNestingPattern = #"(<([ou]l)>)\s*(<([ou]l)>)"#
            let directNestingRegex = try NSRegularExpression(pattern: directNestingPattern, options: [])
            let directNestingRange = NSRange(result.startIndex..<result.endIndex, in: result)
            
            result = directNestingRegex.stringByReplacingMatches(
                in: result,
                range: directNestingRange,
                withTemplate: "$1<li>$3"
            )
            print(">>>DEB After fixing direct nesting: \(result)")
            
            // Normalize whitespace between list elements
            let whitespacePattern = #"(</li>)\s+(</[ou]l>)"#
            let whitespaceRegex = try NSRegularExpression(pattern: whitespacePattern, options: [])
            let whitespaceRange = NSRange(result.startIndex..<result.endIndex, in: result)
            
            result = whitespaceRegex.stringByReplacingMatches(
                in: result,
                range: whitespaceRange,
                withTemplate: "$1$2"
            )
            print(">>>DEB After whitespace normalization: \(result)")
            
            // Important fix: Make sure nested lists are wrapped in list items
            // Pattern: <ul>...<ul> (without <li> in between)
            let nestedListPattern = #"(<[ou]l>[^<]*?)(<[ou]l>)"#
            let nestedListRegex = try NSRegularExpression(pattern: nestedListPattern, options: [])
            let nestedListRange = NSRange(result.startIndex..<result.endIndex, in: result)
            
            result = nestedListRegex.stringByReplacingMatches(
                in: result, 
                range: nestedListRange,
                withTemplate: "$1<li>$2"
            )
            print(">>>DEB After fixing nested lists: \(result)")
            
            // Fix case where <br /> is used before nested list
            // Example: <li>point 3<br /><ol>... -> <li>point 3</li><ol>...
            let brNestingPattern = #"<li>(.*?)<br\s*/?\s*>(\s*<[ou]l>)"#
            let brNestingRegex = try NSRegularExpression(
                pattern: brNestingPattern,
                options: [.dotMatchesLineSeparators]
            )
            let brNestingRange = NSRange(result.startIndex..<result.endIndex, in: result)
            
            result = brNestingRegex.stringByReplacingMatches(
                in: result,
                range: brNestingRange,
                withTemplate: "<li>$1</li>$2"
            )
            print(">>>DEB After fixing br tags: \(result)")
            
            // Set data-nested attributes for proper indentation tracking
            // Mark each list with its nesting level
            var orderedListLevel = 0
            var unorderedListLevel = 0
            var replacements: [(NSRange, String)] = []
            
            // Find all list start tags
            let listStartPattern = #"<(ol|ul)([^>]*)>"#
            let listStartRegex = try NSRegularExpression(pattern: listStartPattern, options: [])
            
            listStartRegex.enumerateMatches(in: result, range: NSRange(result.startIndex..<result.endIndex, in: result)) { match, _, _ in
                guard let match = match,
                      let matchRange = Range(match.range, in: result),
                      let tagRange = Range(match.range(at: 1), in: result),
                      let attrsRange = Range(match.range(at: 2), in: result) else {
                    return
                }
                
                let tag = result[tagRange]
                let attrs = result[attrsRange]
                
                if tag == "ol" {
                    orderedListLevel += 1
                    replacements.append((match.range, "<ol\(attrs) data-level=\"\(orderedListLevel)\" data-ordered=\"true\">"))
                } else if tag == "ul" {
                    unorderedListLevel += 1
                    replacements.append((match.range, "<ul\(attrs) data-level=\"\(unorderedListLevel)\" data-unordered=\"true\">"))
                }
            }
            
            // Apply replacements
            for (range, replacement) in replacements.reversed() {
                let nsResult = NSMutableString(string: result)
                nsResult.replaceCharacters(in: range, with: replacement)
                result = nsResult as String
            }
            
            // Reset counters when list ends
            replacements = []
            let listEndPattern = #"</(ol|ul)>"#
            let listEndRegex = try NSRegularExpression(pattern: listEndPattern, options: [])
            
            listEndRegex.enumerateMatches(in: result, range: NSRange(result.startIndex..<result.endIndex, in: result)) { match, _, _ in
                guard let match = match,
                      let tagRange = Range(match.range(at: 1), in: result) else {
                    return
                }
                
                let tag = result[tagRange]
                
                if tag == "ol" {
                    if orderedListLevel > 0 {
                        orderedListLevel -= 1
                    }
                } else if tag == "ul" {
                    if unorderedListLevel > 0 {
                        unorderedListLevel -= 1
                    }
                }
            }
            
            print(">>>DEB After adding nesting levels: \(result.prefix(100))")
            processedHTML = result
            
        } catch {
            print(">>>DEB ❌ Error fixing nested lists: \(error)")
        }
        
        print(">>>DEB 🏁 fixNestedLists - END")
        return processedHTML
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
            
            // Извлекаем alt текст, если он есть
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
        // Базовый параграф-стиль
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 8
        
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
        return AttributedString(converter.convert(html: html))
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
//swiftlint: enable all
