//
//  TextConverter.swift
//  HTMLStreamer
//
//  Created by Shadowfacts on 12/19/23.
//

import Foundation

//swiftlint: disable all
public class TextConverter<Callbacks: HTMLConversionCallbacks> {
    private let configuration: TextConverterConfiguration
    
    private var tokenizer: Tokenizer<String.UnicodeScalarView.Iterator>!
    private var str: String!
    
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
    var blockStateMachine = BlockStateMachine(blockBreak: "", lineBreak: "", listIndentForContentOutsideItem: "", append: { _ in }, removeChar: {})
    private var currentElementIsEmpty = true
    private var currentRun = ""
    
    public convenience init(configuration: TextConverterConfiguration = .init()) where Callbacks == DefaultCallbacks {
        self.init(configuration: configuration, callbacks: DefaultCallbacks.self)
    }
    
    public init(configuration: TextConverterConfiguration = .init(), callbacks _: Callbacks.Type = Callbacks.self) {
        self.configuration = configuration
    }
    
    public func convert(html: String) -> String {
        tokenizer = Tokenizer(chars: html.unicodeScalars.makeIterator())
        str = ""
        
        blockStateMachine = BlockStateMachine(
            blockBreak: configuration.insertNewlines ? "\n\n" : " " ,
            lineBreak: configuration.insertNewlines ? "\n" : " " ,
            listIndentForContentOutsideItem: "",
            append: { [unowned self] in
                self.append($0)
            }, removeChar: { [unowned self] in
                self.removeChar()
            })
        currentElementIsEmpty = true
        currentRun = ""
        
        while let token = tokenizer.next() {
            switch token {
            case .character(let scalar):
                currentElementIsEmpty = false
                if blockStateMachine.continueBlock(char: scalar),
                   !hasSkipOrReplaceElementAction {
                    currentRun.unicodeScalars.append(scalar)
                }
            case .characterSequence(let string):
                currentElementIsEmpty = false
                for c in string.unicodeScalars {
                    if blockStateMachine.continueBlock(char: c),
                       !hasSkipOrReplaceElementAction {
                        currentRun.unicodeScalars.append(c)
                    }
                }
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
                if let action = actionStack.last {
                    if action != .default {
                        finishRun()
                    }
                    actionStack.removeLast()
                }
            case .comment, .doctype:
                break
            }
        }
        
        blockStateMachine.endBlocks()
        finishRun()
        
        return str
    }
    
    private func handleStartTag(_ name: String, selfClosing: Bool, attributes: [Attribute]) {
        switch name {
        case "br":
            blockStateMachine.breakTag()
        case "pre", "blockquote", "p", "ol", "ul":
            blockStateMachine.startOrEndBlock()
        default:
            break
        }
    }
    
    private func handleEndTag(_ name: String) {
        switch name {
        case "pre", "blockquote", "p", "ol", "ul":
            blockStateMachine.startOrEndBlock()
            finishRun()
        default:
            break
        }
    }
    
    var blockBreak: String {
        if configuration.insertNewlines {
            "\n\n"
        } else {
            " "
        }
    }
    
    var lineBreak: String {
        if configuration.insertNewlines {
            "\n"
        } else {
            " "
        }
    }
    
    var listIndentForContentOutsideItem: String {
        " "
    }
    
    func append(_ s: String) {
        currentRun.append(s)
    }
    
    func removeChar() {
        if currentRun.isEmpty {
            str.removeLast()
        } else {
            currentRun.removeLast()
        }
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
        
        str.append(currentRun)
        currentRun = ""
    }
    
}

public struct TextConverterConfiguration {
    public var insertNewlines: Bool
    
    public init(insertNewlines: Bool = true) {
        self.insertNewlines = insertNewlines
    }
}
//swiftlint: enable all
