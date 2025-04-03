//
//  AttributedStringConverter.swift
//  HTMLStreamer
//
//  Created by Shadowfacts on 11/24/23.
//

#if os(iOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import Theme

#if os(iOS) || os(visionOS)
private typealias PlatformFont = UIFont
#elseif os(macOS)
private typealias PlatformFont = NSFont
#endif

//swiftlint: disable all
public class AttributedStringConverter<Callbacks: HTMLConversionCallbacks> {
    private let configuration: AttributedStringConverterConfiguration
    // There are only 8 combinations of FontTraits
    private var fontCache: [PlatformFont?] = Array(repeating: nil, count: 8)
    
    private var tokenizer: Tokenizer<String.UnicodeScalarView.Iterator>!
    private var str: NSMutableAttributedString!
    
    private var actionStack: [ElementAction] = [] {
        didSet {
            hasSkipOrReplaceElementAction = actionStack.contains(where: {
                switch $0 {
                case .skip, .replace(_):
                    true
                default:
                    false
                }
            })
        }
    }
    private var hasSkipOrReplaceElementAction = false
    private var styleStack: [Style] = []
    private var blockStateMachine = BlockStateMachine(
        blockBreak: "",
        lineBreak: "",
        listIndentForContentOutsideItem: "",
        append: { _ in
        },
        removeChar: {})
    private var currentElementIsEmpty = true
    private var previouslyFinishedListItem = false
    // The current run of text w/o styles changing
    private var currentRun: String = ""
    
    // Dictionary to store nesting level of lists by their index position in the document
    private var listNestingLevels: [Int: Int] = [:]
    private var currentListIndex = 0
    
    // Track active list types (ordered vs unordered) to avoid cross-nesting
    private var activeOrderedListCount = 0
    private var activeUnorderedListCount = 0
    
    @MainActor private var orderedTextList = OrderedNumberTextList(markerFormat: .decimal, options: 0)
    @MainActor private var unorderedTextList = NSTextList(markerFormat: .disc, options: 0)
    
    public convenience init(configuration: AttributedStringConverterConfiguration) where Callbacks == DefaultCallbacks {
        self.init(configuration: configuration, callbacks: DefaultCallbacks.self)
    }
    
    public init(configuration: AttributedStringConverterConfiguration, callbacks _: Callbacks.Type = Callbacks.self) {
        self.configuration = configuration
    }
    
    @MainActor public func convert(html: String) -> NSAttributedString {
        print(">>>DEB 🔄 Starting HTML conversion")
        // Clear any pending state from previous conversions
        tokenizer = Tokenizer(chars: html.unicodeScalars.makeIterator())
        str = NSMutableAttributedString()
        
        actionStack = []
        styleStack = []
        listNestingLevels = [:]
        currentListIndex = 0
        activeOrderedListCount = 0
        activeUnorderedListCount = 0
        blockStateMachine = BlockStateMachine(
            blockBreak: "\n\n",
            lineBreak: "\n",
            listIndentForContentOutsideItem: "\t\t",
            append: { [unowned self] in
                self.append($0)
            },
            removeChar: { [unowned self] in
            self.removeChar()
        })
        currentElementIsEmpty = true
        previouslyFinishedListItem = false
        currentRun = ""
        
        // First, let's preprocess and fix the HTML for better handling of lists
        let htmlProcessor = HTMLContentFixProcessor()
        let fixedHTML = htmlProcessor.fixListStructure(html)
        
        // Reset tokenizer with the fixed HTML
        tokenizer = Tokenizer(chars: fixedHTML.unicodeScalars.makeIterator())
        
        while let token = tokenizer.next() {
            switch token {
            case .character(let c):
                currentElementIsEmpty = false
                if blockStateMachine.continueBlock(char: c),
                   !hasSkipOrReplaceElementAction {
                    currentRun.unicodeScalars.append(c)
                }
            case .characterSequence(let s):
                currentElementIsEmpty = false
                for c in s.unicodeScalars {
                    if blockStateMachine.continueBlock(char: c),
                       !hasSkipOrReplaceElementAction {
                        currentRun.unicodeScalars.append(c)
                    }
                }
            case .comment:
                // ignored
                continue
            case .startTag(let name, let selfClosing, let attributes):
                currentElementIsEmpty = true
                let action = Callbacks.elementAction(name: name, attributes: attributes)
                if action != .default {
                    finishRun()
                }
                actionStack.append(action)
                handleStartTag(name, selfClosing: selfClosing, attributes: attributes)
            case .endTag(let name):
                handleEndTag(name)
                // if we have a non-default action for the current element, the run finishes here
                if let action = actionStack.last {
                    if action != .default {
                        finishRun()
                    }
                    actionStack.removeLast()
                }
            case .doctype:
                // ignored
                continue
            }
        }
        
        blockStateMachine.endBlocks()
        finishRun()
        
        return str
    }
    
    @MainActor private func handleStartTag(_ name: String, selfClosing: Bool, attributes: [Attribute]) {
        if name == "br" {
            blockStateMachine.breakTag()
            return
        }
        // self closing tags are ignored since they have no content
        guard !selfClosing else {
            return
        }
        
        switch name {
        case "a":
            // we need to always insert in attribute, because we need to always have one
            // to remove from the stack in handleEndTag
            // but we only need to finish the run if we have a URL, since otherwise
            // the final attribute run won't be affected
            let url = attributes.attributeValue(for: "href").flatMap(Callbacks.makeURL(string:))
            if url != nil {
                finishRun()
            }
            styleStack.append(.link(url))
        case "em", "i":
            finishRun()
            styleStack.append(.italic)
        case "strong", "b":
            finishRun()
            styleStack.append(.bold)
        case "del":
            finishRun()
            styleStack.append(.strikethrough)
        case "code":
            finishRun()
            styleStack.append(.monospace)
        case "pre":
            blockStateMachine.startOrEndBlock()
            blockStateMachine.startPreformatted()
            finishRun()
            styleStack.append(.monospace)
        case "blockquote":
            blockStateMachine.startOrEndBlock()
            finishRun()
            styleStack.append(.blockquote)
        case "p":
            blockStateMachine.startOrEndBlock()
        case "ol":
            blockStateMachine.startOrEndBlock()
            finishRun()
            
            // Increment the active ordered list counter
            activeOrderedListCount += 1
            
            let parentLevel = styleStack.filter { style in
                if case .orderedList = style { return true }
                if case .unorderedList = style { return true }
                return false
            }.count
            
            // Store this list's nesting level
            currentListIndex += 1
            listNestingLevels[currentListIndex] = parentLevel + 1
            
            styleStack.append(.orderedList(nextElementOrdinal: 1))
        case "ul":
            blockStateMachine.startOrEndBlock()
            finishRun()
            
            // Increment the active unordered list counter
            activeUnorderedListCount += 1
            
            let parentLevel = styleStack.filter { style in
                if case .orderedList = style { return true }
                if case .unorderedList = style { return true }
                return false
            }.count
            
            // Store this list's nesting level
            currentListIndex += 1
            listNestingLevels[currentListIndex] = parentLevel + 1
            
            styleStack.append(.unorderedList)
        case "li":
            // Ensure we start a new line for list items
            blockStateMachine.startListItem()
            finishRun()
            
            // Find nesting level by counting list styles in the stack
            let listStyles = styleStack.filter { style in
                if case .orderedList = style { return true }
                if case .unorderedList = style { return true }
                return false
            }
            
            guard listStyles.count > 0 else { break }
            
            // Determine if this is an ordered or unordered list item
            let isOrdered = listStyles.last.map { style in
                if case .orderedList = style { return true }
                return false
            } ?? false
            
            // Get the marker and update the counter for ordered lists
            let marker: String
            if isOrdered, case .orderedList(let nextElementOrdinal) = styleStack.last! {
                marker = "\(nextElementOrdinal)."
                // Update the counter for the next item
                styleStack[styleStack.count - 1] = .orderedList(nextElementOrdinal: nextElementOrdinal + 1)
            } else {
                marker = "•"
            }
            
            let nestingLevel = listStyles.count
            if nestingLevel > 1 {
                // Add spaces for indentation - 5 spaces per level
                let indent = String(repeating: "     ", count: nestingLevel - 1)
                currentRun.append("\(indent)\(marker) ")
            } else {
                currentRun.append("\(marker) ")
            }
        default:
            break
        }
    }
    
    private func handleEndTag(_ name: String) {
        switch name {
        case "a":
            if case .link(.some(_)) = lastStyle(.link) {
                finishRun()
            }
            removeLastStyle(.link)
        case "em", "i":
            finishRun()
            removeLastStyle(.italic)
        case "strong", "b":
            finishRun()
            removeLastStyle(.bold)
        case "del":
            finishRun()
            removeLastStyle(.strikethrough)
        case "code":
            finishRun()
            removeLastStyle(.monospace)
        case "pre":
            finishRun()
            removeLastStyle(.monospace)
            blockStateMachine.startOrEndBlock()
            blockStateMachine.endPreformatted()
        case "blockquote":
            finishRun()
            removeLastStyle(.blockquote)
            blockStateMachine.startOrEndBlock()
        case "p":
            blockStateMachine.startOrEndBlock()
        case "ol":
            finishRun()
            removeLastStyle(.orderedList)
            // Decrease the active ordered list count when exiting an ordered list
            if activeOrderedListCount > 0 {
                activeOrderedListCount -= 1
            }
            blockStateMachine.startOrEndBlock()
            previouslyFinishedListItem = false
        case "ul":
            finishRun()
            removeLastStyle(.unorderedList)
            // Decrease the active unordered list count when exiting an unordered list
            if activeUnorderedListCount > 0 {
                activeUnorderedListCount -= 1
            }
            blockStateMachine.startOrEndBlock()
            previouslyFinishedListItem = false
        case "li":
            finishRun()
            previouslyFinishedListItem = true
            blockStateMachine.endListItem()
        default:
            break
        }
    }
    
    var blockBreak: String {
        "\n\n"
    }
    
    var lineBreak: String {
        "\n"
    }
    
    var listIndentForContentOutsideItem: String {
        "\t\t"
    }
    
    func append(_ s: String) {
        currentRun.append(s)
    }
    
    func removeChar() {
        if currentRun.isEmpty {
            str.deleteCharacters(in: NSRange(location: str.length - 1, length: 1))
        } else {
            currentRun.removeLast()
        }
    }
    
    // Finds the last currently-open style of the given type.
    // We can't just use the last one because we need to handle mis-nested tags.
    private func removeLastStyle(_ type: Style.StyleType) {
        var i = styleStack.index(before: styleStack.endIndex)
        while i >= styleStack.startIndex {
            if styleStack[i].type == type {
                styleStack.remove(at: i)
                return
            }
            styleStack.formIndex(before: &i)
        }
    }
    
    private func lastStyle(_ type: Style.StyleType) -> Style? {
        styleStack.last { $0.type == type }
    }
    
    private lazy var blockquoteParagraphStyle: NSParagraphStyle = {
        let style = configuration.paragraphStyle.mutableCopy() as! NSMutableParagraphStyle
        style.headIndent = 32
        style.firstLineHeadIndent = 32
        return style
    }()
    
    private lazy var listParagraphStyle: NSParagraphStyle = {
        let style = configuration.paragraphStyle.mutableCopy() as! NSMutableParagraphStyle
        // I don't like that I can't just use paragraphStyle.textLists, because it makes the list markers
        // not use the monospace digit font (it seems to just use whatever font attribute is set for the whole thing),
        // and it doesn't right align the list markers.
        // Unfortunately, doing it manually means the list markers are incldued in the selectable text.
        style.headIndent = 32
        style.firstLineHeadIndent = 0
        // Use 2 tab stops, one for the list marker, the second for the content.
        style.tabStops = [
            NSTextTab(textAlignment: .right, location: 28),
            NSTextTab(textAlignment: .natural, location: 32)
        ]
        return style
    }()
    
    // Get paragraph style with indentation appropriate for the current nesting level
    private func getListParagraphStyle() -> NSParagraphStyle {
        print(">>>DEB 📐 Getting list paragraph style")
        let style = configuration.paragraphStyle.mutableCopy() as! NSMutableParagraphStyle

        // No tab stops or special formatting needed
        style.tabStops = []
        
        // Simple paragraph spacing
        style.paragraphSpacing = 2
        style.paragraphSpacingBefore = 2
        
        // No indentation at paragraph level - we handle it directly in the text
        style.headIndent = 0
        style.firstLineHeadIndent = 0
        
        print(">>>DEB 📐 Paragraph style configured - tabStops: \(style.tabStops.count), headIndent: \(style.headIndent), firstLineHeadIndent: \(style.firstLineHeadIndent)")
        return style
    }
    
    private func finishRun() {
        if case .append(let s) = actionStack.last {
            currentRun.append(s)
        } else if case .replace(let replacement) = actionStack.last {
            currentRun.append(replacement)
        }
        
        guard !currentRun.isEmpty else {
            return
        }

        var attributes = [NSAttributedString.Key: Any]()
        var paragraphStyle = configuration.paragraphStyle
        var currentFontTraits: FontTrait = []
        for style in styleStack {
            switch style {
            case .bold:
                currentFontTraits.insert(.bold)
            case .italic:
                currentFontTraits.insert(.italic)
            case .monospace:
                currentFontTraits.insert(.monospace)
            case .link(let url):
                if let url {
                    attributes[.link] = url
                    attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
                    attributes[.foregroundColor] = Theme.UIColors.accentColor
                }
            case .strikethrough:
                attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
            case .blockquote:
                paragraphStyle = blockquoteParagraphStyle
            case .orderedList, .unorderedList:
                paragraphStyle = getListParagraphStyle()
            }
        }
        
        attributes[.font] = getFont(traits: currentFontTraits)
        if attributes[.foregroundColor] == nil {
            attributes[.foregroundColor] = configuration.color
        }
        
        attributes[.paragraphStyle] = paragraphStyle
        
        str.append(NSAttributedString(string: currentRun, attributes: attributes))
        currentRun = ""
    }
    
    private func getFont(traits: FontTrait) -> PlatformFont? {
        if let cached = fontCache[traits.rawValue] {
            return cached
        }
        
        let baseFont = traits.contains(.monospace) ? configuration.monospaceFont : configuration.font
        var descriptor = baseFont.fontDescriptor
        if traits.contains(.bold) && traits.contains(.italic),
           let boldItalic = descriptor.withSymbolicTraits([.traitBold, .traitItalic]) {
            descriptor = boldItalic
        } else if traits.contains(.bold),
           let bold = descriptor.withSymbolicTraits(.traitBold) {
            descriptor = bold
        } else if traits.contains(.italic),
           let italic = descriptor.withSymbolicTraits(.traitItalic) {
            descriptor = italic
        } else {
            // N.B.: this does not go through the UIFontMetrics, the configuration fonts are expected to be setup for Dynamic Type already
            fontCache[traits.rawValue] = baseFont
            return baseFont
        }
        let font = PlatformFont(descriptor: descriptor, size: 0)
        #if os(iOS) || os(visionOS)
        let scaled = configuration.fontMetrics.scaledFont(for: font)
        fontCache[traits.rawValue] = scaled
        return scaled
        #else
        fontCache[traits.rawValue] = font
        return font
        #endif
    }
}

public struct AttributedStringConverterConfiguration {
    #if os(iOS) || os(visionOS)
    public var font: UIFont
    public var monospaceFont: UIFont
    public var fontMetrics: UIFontMetrics
    public var color: UIColor
    #elseif os(macOS)
    public var font: NSFont
    public var monospaceFont: NSFont
    public var color: NSColor
    #endif
    public var paragraphStyle: NSParagraphStyle
    
    #if os(iOS) || os(visionOS)
    public init(
        font: UIFont,
        monospaceFont: UIFont,
        fontMetrics: UIFontMetrics,
        color: UIColor,
        paragraphStyle: NSParagraphStyle
    ) {
        self.font = font
        self.monospaceFont = monospaceFont
        self.fontMetrics = fontMetrics
        self.color = color
        self.paragraphStyle = paragraphStyle
    }
    #elseif os(macOS)
    public init(
        font: NSFont,
        monospaceFont: NSFont,
        color: NSColor,
        paragraphStyle: NSParagraphStyle
    ) {
        self.font = font
        self.monospaceFont = monospaceFont
        self.color = color
        self.paragraphStyle = paragraphStyle
    }
    #endif
}

#if os(macOS)
private extension NSFontDescriptor {
    func withSymbolicTraits(_ traits: SymbolicTraits) -> NSFontDescriptor? {
        let descriptor: NSFontDescriptor = self.withSymbolicTraits(traits)
        return descriptor
    }
}
private extension NSFontDescriptor.SymbolicTraits {
    static var traitBold: Self { .bold }
    static var traitItalic: Self { .italic }
}
#endif

private struct FontTrait: OptionSet, Hashable {
    static let bold = FontTrait(rawValue: 1 << 0)
    static let italic = FontTrait(rawValue: 1 << 1)
    static let monospace = FontTrait(rawValue: 1 << 2)
    
    let rawValue: Int
    
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

private enum Style {
    case bold
    case italic
    case monospace
    case link(URL?)
    case strikethrough
    case blockquote
    case orderedList(nextElementOrdinal: Int)
    case unorderedList
    
    var type: StyleType {
        switch self {
        case .bold:
            return .bold
        case .italic:
            return .italic
        case .monospace:
            return .monospace
        case .link(_):
            return .link
        case .strikethrough:
            return .strikethrough
        case .blockquote:
            return .blockquote
        case .orderedList(nextElementOrdinal: _):
            return .orderedList
        case .unorderedList:
            return .unorderedList
        }
    }
    
    enum StyleType: Equatable {
        case bold
        case italic
        case monospace
        case link
        case strikethrough
        case blockquote
        case orderedList
        case unorderedList
    }
}

extension Collection where Element == Attribute {
    public func attributeValue(for name: String) -> String? {
        first(where: { $0.name == name })?.value
    }
}

private class OrderedNumberTextList: NSTextList {
    override func marker(forItemNumber itemNumber: Int) -> String {
        "\(super.marker(forItemNumber: itemNumber))."
    }
}
//swiftlint: enable all
