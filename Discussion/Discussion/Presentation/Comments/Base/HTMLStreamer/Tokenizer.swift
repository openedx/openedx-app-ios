//
//  Tokenizer.swift
//  HTMLStreamer
//
//  Created by Shadowfacts on 11/22/23.
//

import Foundation

//swiftlint: disable all
struct Tokenizer<Chars: IteratorProtocol<Unicode.Scalar>>: IteratorProtocol {
    typealias Element = Token
    
    private var chars: Chars
    private var reconsumeStack: [Unicode.Scalar] = []
    private var state = State.data
    private var returnState: State?
    private var temporaryBuffer: String?
    private var characterReferenceCode: UInt32?
    // Optimization: using an enum for the current token means we can't modify the associated values in-place
    // Separate fields for everything increases the risk of invalid states, but nets us a small perf gain.
    private var currentStartTag: (String, selfClosing: Bool, attributes: [Attribute])?
    private var currentEndTag: String?
    private var currentComment: String?
    private var currentDoctype: (String, forceQuirks: Bool, publicIdentifier: String?, systemIdentifier: String?)?
    
    init(chars: Chars) {
        self.chars = chars
    }
    
    mutating func next() -> Token? {
        switch state {
        case .flushingTemporaryBuffer(let returnState):
            state = returnState
            if temporaryBuffer == nil || temporaryBuffer!.isEmpty {
                return next()
            } else {
                var buffer: String? = nil
                swap(&buffer, &temporaryBuffer)
                return .characterSequence(buffer!)
            }
        case .endOfFile:
            return nil
        case .emitTokens(var tokens, let nextState):
            if tokens.isEmpty {
                state = nextState
                return next()
            } else {
                let tok = tokens.removeFirst()
                state = .emitTokens(tokens, nextState)
                return tok
            }
            
        case .data:
            return tokenizeData()
        case .characterReference:
            return tokenizeCharacterReference()
        case .namedCharacterReference:
            return tokenizeNamedCharaterReference()
        case .numericCharacterReference:
            return tokenizeNumericCharacterReference()
        case .numericCharacterReferenceEnd:
            return tokenizeNumericCharacterReferenceEnd()
        case .hexadecimalCharacterReferenceStart:
            return tokenizeHexadecimalCharacterReferenceStart()
        case .hexadecimalCharacterReference:
            return tokenizeHexadecimalCharacterReference()
        case .decimalCharacterReferenceStart:
            return tokenizeDecimalCharacterReferenceStart()
        case .decimalCharacterReference:
            return tokenizeDecimalCharacterReference()
        case .ambiguousAmpersand:
            return tokenizeAmbiguousAmpersand()
        case .tagOpen:
            return tokenizeTagOpen()
        case .endTagOpen:
            return tokenizeEndTagOpen()
        case .tagName:
            return tokenizeTagName()
        case .selfClosingStartTag:
            return tokenizeSelfClosingStartTag()
        case .beforeAttributeName:
            return tokenizeBeforeAttributeName()
        case .attributeName:
            return tokenizeAttributeName()
        case .afterAttributeName:
            return tokenizeAfterAttributeName()
        case .beforeAttributeValue:
            return tokenizeBeforeAttributeValue()
        case .attributeValue(let quotes):
            return tokenizeAttributeValue(quotes: quotes)
        case .afterAttributeValueQuoted:
            return tokenizeAfterAttributeValueQuoted()
        case .bogusComment:
            return tokenizeBogusComment()
        case .markupDeclarationOpen:
            return tokenizeMarkupDeclarationOpen()
        case .commentStart:
            return tokenizeCommentStart()
        case .commentStartDash:
            return tokenizeCommentStartDash()
        case .comment:
            return tokenizeComment()
        case .commentLessThanSign:
            return tokenizeCommentLessThanSign()
        case .commentLessThanSignBang:
            return tokenizeCommentLessThanSignBang()
        case .commentLessThanSignBangDash:
            return tokenizeCommentLessThanSignBangDash()
        case .commentLessThanSignBangDashDash:
            return tokenizeCommentLessThanSignBangDashDash()
        case .commentEndDash:
            return tokenizeCommentEndDash()
        case .commentEnd:
            return tokenizeCommentEnd()
        case .commentEndBang:
            return tokenizeCommentEndBang()
        case .doctype:
            return tokenizeDoctype()
        case .beforeDoctypeName:
            return tokenizeBeforeDoctypeName()
        case .doctypeName:
            return tokenizeDoctypeName()
        case .afterDoctypeName:
            return tokenizeAfterDoctypeName()
        case .afterDoctypePublicKeyword:
            return tokenizeAfterDoctypePublicKeyword()
        case .beforeDoctypePublicIdentifier:
            return tokenizeBeforeDoctypePublicIdentifier()
        case .doctypePublicIdentifier(let quotes):
            return tokenizeDoctypePublicIdentifier(quotes: quotes)
        case .afterDoctypePublicIdentifier:
            return tokenizeAfterDoctypePublicIdentifier()
        case .betweenDoctypePublicAndSystemIdentifiers:
            return tokenizeBetweenDoctypePublicAndSystemIdentifiers()
        case .afterDoctypeSystemKeyword:
            return tokenizeAfterDoctypeSystemKeyword()
        case .beforeDoctypeSystemIdentifier:
            return tokenizeBeforeDoctypeSystemIdentifier()
        case .doctypeSystemIdentifier(let quotes):
            return tokenizeDoctypeSystemIdentifier(quotes: quotes)
        case .afterDoctypeSystemIdentifier:
            return tokenizeAfterDoctypeSystemIdentifier()
        case .bogusDoctype:
            return tokenizeBogusDoctype()
        }
    }
    
    private mutating func reconsume(_ c: Unicode.Scalar?) {
        if let c {
            reconsumeStack.append(c)
        }
    }
    
    private mutating func nextChar() -> Unicode.Scalar? {
        if !reconsumeStack.isEmpty {
            return reconsumeStack.removeLast()
        } else {
            return chars.next()
        }
    }
    
    private mutating func peekChar() -> Unicode.Scalar? {
        if let nextToReconsume = reconsumeStack.last {
            return nextToReconsume
        } else {
            let c = chars.next()
            if let c {
                reconsume(c)
            }
            return c
        }
    }
    
    // TODO: extract this all out into a standalone type and test it separately
    private mutating func peek(count: Int) -> String {
        precondition(count >= 0)
        var buf = String.UnicodeScalarView()
        for _ in 0..<count {
            if let c = nextChar() {
                buf.append(c)
            } else {
                break
            }
        }
        reconsumeStack.append(contentsOf: buf.reversed())
        return String(buf)
    }
    
    private mutating func consume(count: Int) {
        precondition(count >= 0)
        for _ in 0..<count {
            _ = nextChar()
        }
    }
    
    private mutating func takeCurrentToken() -> Token {
        if let currentStartTag {
            self.currentStartTag = nil
            return .startTag(currentStartTag.0, selfClosing: currentStartTag.selfClosing, attributes: currentStartTag.attributes)
        } else if let currentEndTag {
            self.currentEndTag = nil
            return .endTag(currentEndTag)
        } else if let currentComment {
            self.currentComment = nil
            return .comment(currentComment)
        } else if let currentDoctype {
            self.currentDoctype = nil
            return .doctype(currentDoctype.0, forceQuirks: currentDoctype.forceQuirks, publicIdentifier: currentDoctype.publicIdentifier, systemIdentifier: currentDoctype.systemIdentifier)
        } else {
            preconditionFailure("takeCurrentToken called without current token")
        }
    }
}

enum Token: Equatable {
    case character(Unicode.Scalar)
    case characterSequence(String)
    case comment(String)
    case startTag(String, selfClosing: Bool, attributes: [Attribute])
    case endTag(String)
    case doctype(String, forceQuirks: Bool, publicIdentifier: String?, systemIdentifier: String?)
}

public struct Attribute: Equatable {
    public var name: String
    public var value: String
}

private enum State {
    // Internal states used by the tokenizer
    indirect case flushingTemporaryBuffer(State)
    case endOfFile
    indirect case emitTokens([Token], State)
    
    // States defined by the spec
    case data
    // RCDATA not currently supported
//    case rcdata
    // RAWTEXT not currently supported
//    case rawtext
    // script tag not currently supported
//    case scriptData
    // plaintext tag not currently supported
//    case plaintext
    case tagOpen
    case endTagOpen
    case tagName
    // RCDATA not currently supported
//    case rcdataLessThanSign
//    case rcdataEndTagOpen
//    case rcdataEndTagName
    // RAWTEXT not currently supported
//    case rawtextLessThanSign
//    case rawtextEndTagOpen
//    case rawtextEndTagName
    // script not currently supported
//    case scriptDataLessThanSign
//    case scriptDataEndTagOpen
//    case scriptDataEndTagName
//    case scriptDataEscapeStart
//    case scriptDataEscapeStartDash
//    case scriptDataEscaped
//    case scriptDataEscapedDash
//    case scriptDataEscapedDashDash
//    case scriptDataEscapedLessThanSign
//    case scriptDataEscapedEndTagOpen
//    case scriptDataEscapedEndTagName
//    case scriptDataDoubleEscapeStart
//    case scriptDataDoubleEscaped
//    case scriptDataDoubleEscapedDash
//    case scriptDataDoubleEscapedDashDash
//    case scriptDataDoubleEscapedLessThanSign
//    case scriptDataDoubleEscapeEnd
    case beforeAttributeName
    case attributeName
    case afterAttributeName
    case beforeAttributeValue
    case attributeValue(AttributeValueQuotation)
    case afterAttributeValueQuoted
    case selfClosingStartTag
    case bogusComment
    case markupDeclarationOpen
    case commentStart
    case commentStartDash
    case comment
    case commentLessThanSign
    case commentLessThanSignBang
    case commentLessThanSignBangDash
    case commentLessThanSignBangDashDash
    case commentEndDash
    case commentEnd
    case commentEndBang
    case doctype
    case beforeDoctypeName
    case doctypeName
    case afterDoctypeName
    case afterDoctypePublicKeyword
    case beforeDoctypePublicIdentifier
    case doctypePublicIdentifier(DoctypeIdentifierQuotation)
    case afterDoctypePublicIdentifier
    case betweenDoctypePublicAndSystemIdentifiers
    case afterDoctypeSystemKeyword
    case beforeDoctypeSystemIdentifier
    case doctypeSystemIdentifier(DoctypeIdentifierQuotation)
    case afterDoctypeSystemIdentifier
    case bogusDoctype
    // CDATA not currently supported
//    case cdataSection
//    case cdataSectionBracket
//    case cdataSectionEndState
    case characterReference
    case namedCharacterReference
    case ambiguousAmpersand
    case numericCharacterReference
    case hexadecimalCharacterReferenceStart
    case decimalCharacterReferenceStart
    case hexadecimalCharacterReference
    case decimalCharacterReference
    case numericCharacterReferenceEnd
}

private enum AttributeValueQuotation {
    case singleQuoted, doubleQuoted, unquoted
}

private enum DoctypeIdentifierQuotation {
    case singleQuoted, doubleQuoted
}

private extension Tokenizer {
    mutating func tokenizeData() -> Token? {
        // Optimization: It's common to have runs of characters that are tokenized as-is,
        // so try to return them as a single token so the downstream consumer
        // can avoid repeated work.
        var buf = ""
        while true {
            switch nextChar() {
            case "&":
                returnState = .data
                state = .characterReference
                if buf.isEmpty {
                    return tokenizeCharacterReference()
                } else {
                    return .characterSequence(buf)
                }
            case "<":
                state = .tagOpen
                if buf.isEmpty {
                    return tokenizeTagOpen()
                } else {
                    return .characterSequence(buf)
                }
            case "\0":
                if buf.isEmpty {
                    return .character("\0")
                } else {
                    reconsume("\0")
                    return .characterSequence(buf)
                }
            case nil:
                if buf.isEmpty {
                    return nil // end of file
                } else {
                    return .characterSequence(buf)
                }
            case .some(let c):
                buf.unicodeScalars.append(c)
                continue
            }
        }
    }
    
    mutating func tokenizeCharacterReference() -> Token? {
        temporaryBuffer = "&"
        guard let c = nextChar() else {
            reconsume(nil)
            state = .flushingTemporaryBuffer(returnState!)
            return next()
        }
        switch c {
        case "a"..."z", "A"..."Z", "0"..."9":
            reconsume(c)
            state = .namedCharacterReference
            return tokenizeNamedCharaterReference()
        case "#":
            temporaryBuffer!.append("#")
            state = .numericCharacterReference
            return tokenizeNumericCharacterReference()
        default:
            reconsume(c)
            state = returnState!
            return next()
        }
    }
    
    mutating func tokenizeNamedCharaterReference() -> Token? {
        // consume as many [a-zA-Z0-9] as possible, until semicolon
        loop: while let c = nextChar() {
            switch c {
            case "a"..."z", "A"..."Z", "0"..."9":
                temporaryBuffer!.unicodeScalars.append(c)
            case ";":
                temporaryBuffer!.unicodeScalars.append(c)
                break loop
            default:
                reconsume(c)
                break loop
            }
        }
        
        var referent = namedCharactersDecodeMap[String(temporaryBuffer!.dropFirst())]
        if referent == nil {
            // start from the beginning and try to find a reference
            var key = ";"
            let buf = temporaryBuffer!
            var index = buf.index(after: buf.startIndex)
            while index < buf.endIndex {
                key.replaceSubrange(key.index(before: key.endIndex)..., with: "\(buf[index]);")
                buf.formIndex(after: &index)
                referent = namedCharactersDecodeMap[key]
                if referent != nil {
                    break
                }
            }
            if referent != nil {
                for c in buf[index...].unicodeScalars.reversed() {
                    reconsume(c)
                }
                temporaryBuffer!.removeSubrange(index...)
            }
        }
        
        if let referent {
            if case .attributeValue(_) = returnState,
               temporaryBuffer!.last != ";",
               let next = peekChar(),
               next == "=" || ("a"..."z").contains(next) || ("A"..."Z").contains(next) || ("0"..."9").contains(next) {
                flushCharacterReference()
            } else {
                temporaryBuffer = "\(referent)"
                flushCharacterReference()
            }
        } else {
            state = .flushingTemporaryBuffer(.ambiguousAmpersand)
        }
        
        return next()
    }
    
    mutating func flushCharacterReference() {
        if case .attributeValue(_) = returnState {
            currentStartTag!.attributes.uncheckedLast.value.append(temporaryBuffer!)
            temporaryBuffer = nil
            state = returnState!
        } else {
            state = .flushingTemporaryBuffer(returnState!)
        }
    }
    
    mutating func tokenizeNumericCharacterReference() -> Token? {
        characterReferenceCode = 0
        switch nextChar() {
        case "x", "X":
            temporaryBuffer!.append("x")
            state = .hexadecimalCharacterReference
            return tokenizeHexadecimalCharacterReference()
        case let c:
            reconsume(c)
            state = .decimalCharacterReference
            return tokenizeDecimalCharacterReference()
        }
    }
    
    mutating func tokenizeNumericCharacterReferenceEnd() -> Token? {
        switch characterReferenceCode! {
        case 0:
            // parse error: null-character-reference
            characterReferenceCode = 0xFFFD
        case let c where c > 0x10FFFF:
            // parse error: character-reference-outside-unicode-range
            characterReferenceCode = 0xFFFD
        case 0xD800...0xDBFF, 0xDC00...0xDFFF: // leading and trailing surrogate ranges
            // parse error: surrogate-character-reference
            characterReferenceCode = 0xFFFD
        case let c where Unicode.Scalar(c) == nil:
            // parse error: noncharacter-character-reference
            // "The parser resolves such character references as-is."
            // TODO: idfk what that means
            characterReferenceCode = nil
            state = returnState!
            return next()
        case 0x0D, 0...0x1F /* C0 control */, 0x7F...0x9F:
            // parse error: control-character-reference
            characterReferenceCode = switch characterReferenceCode! {
            case 0x80: 0x20AC
            case 0x82: 0x201A
            case 0x83: 0x0192
            case 0x84: 0x201E
            case 0x85: 0x2026
            case 0x86: 0x2020
            case 0x87: 0x2021
            case 0x88: 0x02C6
            case 0x89: 0x2030
            case 0x8A: 0x0160
            case 0x8B: 0x2039
            case 0x8C: 0x0152
            case 0x8E: 0x017D
            case 0x91: 0x2018
            case 0x92: 0x2019
            case 0x93: 0x201C
            case 0x94: 0x201D
            case 0x95: 0x2022
            case 0x96: 0x2013
            case 0x97: 0x2014
            case 0x98: 0x02DC
            case 0x99: 0x2122
            case 0x9A: 0x0161
            case 0x9B: 0x203A
            case 0x9C: 0x0153
            case 0x9E: 0x017E
            case 0x9F: 0x0178
            case let c: c
            }
        default:
            break
        }
        temporaryBuffer = ""
        if let c = Unicode.Scalar(characterReferenceCode!) {
            temporaryBuffer!.append(Character(c))
        }
        flushCharacterReference()
        return next()
    }
    
    mutating func tokenizeHexadecimalCharacterReferenceStart() -> Token? {
        let c = nextChar()
        switch c {
        case .some("0"..."9"), .some("a"..."f"), .some("A"..."F"):
            reconsume(c)
            state = .hexadecimalCharacterReference
            return tokenizeHexadecimalCharacterReference()
        default:
            // parse error: absence-of-digits-in-numeric-character-reference
            reconsume(c)
            state = .flushingTemporaryBuffer(returnState!)
            return next()
        }
    }
    
    mutating func tokenizeHexadecimalCharacterReference() -> Token? {
        let c = nextChar()
        switch c {
        case .some("0"..."9"), .some("a"..."f"), .some("A"..."F"):
            characterReferenceCode = (characterReferenceCode! * 16) + UInt32(c!.hexDigitValue!)
            return tokenizeHexadecimalCharacterReference()
        case ";":
            state = .numericCharacterReferenceEnd
            return tokenizeNumericCharacterReferenceEnd()
        case let c:
            // parse error: missing-semicolon-after-character-reference
            reconsume(c)
            state = .numericCharacterReferenceEnd
            return tokenizeNumericCharacterReferenceEnd()
        }
    }
    
    mutating func tokenizeDecimalCharacterReferenceStart() -> Token? {
        let c = nextChar()
        if let c,
           c.isASCII && c.isNumber {
            reconsume(c)
            state = .decimalCharacterReference
            return tokenizeDecimalCharacterReference()
        } else {
            // parse error: absence-of-digits-in-numeric-character-reference
            reconsume(c)
            state = returnState!
            return next()
        }
    }
    
    mutating func tokenizeDecimalCharacterReference() -> Token? {
        let c = nextChar()
        switch c {
        case .some("0"..."9"):
            characterReferenceCode = (characterReferenceCode! * 10) + UInt32(c!.hexDigitValue!)
            return tokenizeDecimalCharacterReference()
        case ";":
            state = .numericCharacterReferenceEnd
            return tokenizeNumericCharacterReferenceEnd()
        default:
            // if nil, parse error: missing-semicolon-after-character-reference
            reconsume(c)
            state = .numericCharacterReferenceEnd
            return tokenizeNumericCharacterReferenceEnd()
        }
    }
    
    mutating func tokenizeAmbiguousAmpersand() -> Token? {
        let c = nextChar()
        switch c {
        case .some("0"..."9"), .some("a"..."z"), .some("A"..."Z"):
            if case .attributeValue(_) = returnState {
                currentStartTag!.attributes.uncheckedLast.value.unicodeScalars.append(c!)
                return tokenizeAmbiguousAmpersand()
            } else {
                return .character(c!)
            }
        default:
            // if c == ";", parse error: unknown-named-character-reference
            reconsume(c)
            state = returnState!
            return next()
        }
    }
    
    mutating func tokenizeTagOpen() -> Token? {
        let c = nextChar()
        switch c {
        case "!":
            state = .markupDeclarationOpen
            return tokenizeMarkupDeclarationOpen()
        case "/":
            state = .endTagOpen
            return tokenizeEndTagOpen()
        case "?":
            // parse error: unexpected-question-mark-instead-of-tag-name
            currentComment = ""
            state = .bogusComment
            return tokenizeBogusComment()
        case nil:
            // parser error: eof-before-tag-name
            state = .endOfFile
            return .character("<")
        case .some("a"..."z"), .some("A"..."Z"):
            currentStartTag = ("", selfClosing: false, attributes: [])
            reconsume(c)
            state = .tagName
            return tokenizeTagName()
        case .some(_):
            // parse error: invalid-first-character-of-tag-name
            reconsume(c)
            state = .data
            return .character("<")
        }
    }
    
    mutating func tokenizeEndTagOpen() -> Token? {
        let c = nextChar()
        switch c {
        case .some("a"..."z"), .some("A"..."Z"):
            currentEndTag = ""
            reconsume(c)
            state = .tagName
            return tokenizeTagName()
        case ">":
            // parse error: missing-end-tag-name
            state = .data
            return tokenizeData()
        case nil:
            // parse error: eof-before-tag-name
            state = .emitTokens([.character("/")], .endOfFile)
            return .character("<")
        case .some(let c):
            // parse error: invalid-first-character-of-tag-name
            currentComment = ""
            reconsume(c)
            state = .bogusComment
            return tokenizeBogusComment()
        }
    }
    
    mutating func tokenizeTagName() -> Token? {
        // Optimization: this is a hot path where we stay in this state for a while before emitting a token,
        // and the function call overhead of recursion costs a bit of perf.
        while true {
            switch nextChar() {
            case "\t", "\n", "\u{000C}", " ":
                state = .beforeAttributeName
                return tokenizeBeforeAttributeName()
            case "/":
                state = .selfClosingStartTag
                return tokenizeSelfClosingStartTag()
            case ">":
                state = .data
                return takeCurrentToken()
            case nil:
                // parse error: eof-in-tag
                state = .endOfFile
                return nil
            case .some(var c):
                if c == "\0" {
                    // parse error: unexpected-null-character
                    c = "\u{FFFD}"
                } else if ("A"..."Z").contains(c) {
                    c = c.asciiLowercase
                }
                if currentStartTag != nil {
                    currentStartTag!.0.unicodeScalars.append(c)
                    continue
                } else if currentEndTag != nil {
                    currentEndTag!.unicodeScalars.append(c)
                    continue
                } else {
                    fatalError("bad current token")
                }
            }
        }
    }
    
    mutating func tokenizeSelfClosingStartTag() -> Token? {
        switch nextChar() {
        case ">":
            currentStartTag!.selfClosing = true
            state = .data
            return takeCurrentToken()
        case nil:
            // parse error: eof-in-tag
            state = .endOfFile
            return nil
        case .some(let c):
            // parse error: unexpected-solidus-in-tag
            reconsume(c)
            state = .beforeAttributeName
            return tokenizeBeforeAttributeName()
        }
    }
    
    mutating func tokenizeBeforeAttributeName() -> Token? {
        let c = nextChar()
        switch c {
        case "\t", "\n", "\u{000C}", " ":
            // ignore the character
            return tokenizeBeforeAttributeName()
        case "/", ">", nil:
            reconsume(c)
            state = .afterAttributeName
            return tokenizeAfterAttributeName()
        case "=":
            // parse error: unexpected-equals-sign-before-attribute-name
            currentStartTag!.attributes.append(Attribute(name: "=", value: ""))
            state = .attributeName
            return tokenizeAttributeName()
        default:
            if currentStartTag != nil {
                currentStartTag!.attributes.append(Attribute(name: "", value: ""))
                reconsume(c)
                state = .attributeName
                return tokenizeAttributeName()
            } else if currentEndTag != nil {
                // ignore
                reconsume(c)
                state = .attributeName
                return tokenizeAttributeName()
            } else {
                fatalError("bad current token")
            }
        }
    }
    
    mutating func tokenizeAttributeName() -> Token? {
        while true {
            let c = nextChar()
            switch c {
            case "\t", "\n", "\u{000C}", " ", "/", ">", nil:
                reconsume(c)
                state = .afterAttributeName
                return tokenizeAfterAttributeName()
            case "=":
                state = .beforeAttributeValue
                return tokenizeBeforeAttributeValue()
            case .some(var c):
                if ("A"..."Z").contains(c) {
                    c = c.asciiLowercase
                }
                // if null, parse error: unexpected-null-character
                if c == "\0" {
                    c = "\u{FFFD}"
                }
                // if c in ["\"", "'", "<"], parse error: unexpected-character-in-attribute-name
                if currentStartTag != nil {
                    currentStartTag!.attributes.uncheckedLast.name.unicodeScalars.append(c)
                    continue
                } else if currentEndTag != nil {
                    continue
                } else {
                    fatalError("bad curren token")
                }
            }
        }
    }
    
    mutating func tokenizeAfterAttributeName() -> Token? {
        switch nextChar() {
        case "\t", "\n", "\u{000C}", " ":
            // ignore the character
            return tokenizeAfterAttributeName()
        case "/":
            state = .selfClosingStartTag
            return tokenizeSelfClosingStartTag()
        case "=":
            state = .beforeAttributeValue
            return tokenizeBeforeAttributeValue()
        case ">":
            state = .data
            return takeCurrentToken()
        case nil:
            // parse error: eof-in-tag
            state = .endOfFile
            return nil
        case .some(let c):
            if currentStartTag != nil {
                currentStartTag!.attributes.append(Attribute(name: "", value: ""))
                reconsume(c)
                state = .attributeName
                return tokenizeAttributeName()
            } else if currentEndTag != nil {
                reconsume(c)
                state = .attributeName
                return tokenizeAttributeName()
            } else {
                fatalError("bad current token")
            }
        }
    }
    
    mutating func tokenizeBeforeAttributeValue() -> Token? {
        switch nextChar() {
        case "\t", "\n", "\u{000C}", " ":
            // ignore the character
            return tokenizeBeforeAttributeValue()
        case "\"":
            state = .attributeValue(.doubleQuoted)
            return tokenizeAttributeValue(quotes: .doubleQuoted)
        case "'":
            state = .attributeValue(.singleQuoted)
            return tokenizeAttributeValue(quotes: .singleQuoted)
        case ">":
            // parse error: missing-attribute-value
            state = .data
            return takeCurrentToken()
        case let c:
            reconsume(c)
            state = .attributeValue(.unquoted)
            return tokenizeAttributeValue(quotes: .unquoted)
        }
    }
    
    mutating func tokenizeAttributeValue(quotes: AttributeValueQuotation) -> Token? {
        while true {
            if quotes == .unquoted {
                switch nextChar() {
                case "\t", "\n", "\u{000C}", " ":
                    state = .beforeAttributeName
                    return tokenizeBeforeAttributeName()
                case "&":
                    returnState = .attributeValue(.unquoted)
                    state = .characterReference
                    return tokenizeCharacterReference()
                case ">":
                    state = .data
                    return takeCurrentToken()
                case nil:
                    // parse error: eof-in-tag
                    state = .endOfFile
                    return nil
                case .some(let c):
                    // if c in ["\"", "'", "<", "=", "`"], parse error: unexpected-character-in-unquoted-attribute-value
                    if currentStartTag != nil {
                        currentStartTag!.attributes.uncheckedLast.value.unicodeScalars.append(c)
                        continue
                    } else if currentEndTag != nil {
                        continue
                    } else {
                        fatalError("bad current token")
                    }
                }
            } else {
                let c = nextChar()
                switch c {
                case "\"" where quotes == .doubleQuoted:
                    state = .afterAttributeValueQuoted
                    return tokenizeAfterAttributeValueQuoted()
                case "'" where quotes == .singleQuoted:
                    state = .afterAttributeValueQuoted
                    return tokenizeAfterAttributeValueQuoted()
                case "&":
                    returnState = .attributeValue(quotes)
                    state = .characterReference
                    return tokenizeCharacterReference()
                case nil:
                    // parse error: eof-in-tag
                    state = .endOfFile
                    return nil
                case .some(var c):
                    if c == "\0" {
                        // parse error: unexpected-null-character
                        c = "\u{FFFD}"
                    }
                    if currentStartTag != nil {
                        currentStartTag!.attributes.uncheckedLast.value.unicodeScalars.append(c)
                        continue
                    } else if currentEndTag != nil {
                        continue
                    }
                }
            }
        }
    }
    
    mutating func tokenizeAfterAttributeValueQuoted() -> Token? {
        switch nextChar() {
        case "\t", "\n", "\u{000C}", " ":
            state = .beforeAttributeName
            return tokenizeBeforeAttributeName()
        case "/":
            state = .selfClosingStartTag
            return tokenizeSelfClosingStartTag()
        case ">":
            state = .data
            return takeCurrentToken()
        case nil:
            // parse error: eof-in-tag
            state = .endOfFile
            return nil
        case .some(let c):
            // parse error: missing-whitespace-between-attributes
            reconsume(c)
            state = .beforeAttributeName
            return tokenizeBeforeAttributeName()
        }
    }
    
    mutating func tokenizeBogusComment() -> Token? {
        switch nextChar() {
        case ">":
            state = .data
            return takeCurrentToken()
        case nil:
            state = .endOfFile
            return takeCurrentToken()
        case .some(var c):
            if c == "\0" {
                // parse error: unexpected-null-character
                c = "\u{FFFD}"
            }
            currentComment!.unicodeScalars.append(c)
            return tokenizeBogusComment()
        }
    }
    
    mutating func tokenizeMarkupDeclarationOpen() -> Token? {
        let peeked = peek(count: 7)
        if peeked.starts(with: "--") {
            consume(count: 2)
            currentComment = ""
            state = .commentStart
            return tokenizeCommentStart()
        } else if peeked.lowercased() == "doctype" {
            consume(count: 7)
            state = .doctype
            return tokenizeDoctype()
        } else if peeked == "[CDATA[" {
            // TODO: we don't do any of the tree construction stuff yet, so can't really handle this
            // consume(count: 7)
            currentComment = ""
            state = .bogusComment
            return tokenizeBogusComment()
        } else {
            // parse error: incorrectly-opened-comment
            currentComment = ""
            state = .bogusComment
            return tokenizeBogusComment()
        }
    }
    
    mutating func tokenizeCommentStart() -> Token? {
        switch nextChar() {
        case "-":
            state = .commentStartDash
            return tokenizeCommentStartDash()
        case ">":
            // parse error: abrupt-closing-of-empty-comment
            state = .data
            return takeCurrentToken()
        case let c:
            reconsume(c)
            state = .comment
            return tokenizeComment()
        }
    }
    
    mutating func tokenizeCommentStartDash() -> Token? {
        switch nextChar() {
        case "-":
            state = .commentEnd
            return tokenizeCommentEnd()
        case ">":
            // parse error: abrupt-closing-of-empty-comment
            state = .data
            return takeCurrentToken()
        case nil:
            // parse error: eof-in-comment
            return takeCurrentToken()
        case .some(let c):
            currentComment!.append("-")
            reconsume(c)
            state = .comment
            return tokenizeComment()
        }
    }
    
    mutating func tokenizeComment() -> Token? {
        switch nextChar() {
        case "<":
            currentComment!.append("<")
            state = .commentLessThanSign
            return tokenizeCommentLessThanSign()
        case "-":
            state = .commentEndDash
            return tokenizeCommentEndDash()
        case nil:
            // parse error: eof-in-comment
            state = .endOfFile
            return takeCurrentToken()
        case .some(var c):
            if c == "\0" {
                // parse error: unexpected-null-character
                c = "\u{FFFD}"
            }
            currentComment!.unicodeScalars.append(c)
            return tokenizeComment()
        }
    }
    
    mutating func tokenizeCommentLessThanSign() -> Token? {
        switch nextChar() {
        case "!":
            currentComment!.append("!")
            state = .commentLessThanSignBang
            return tokenizeCommentLessThanSignBang()
        case "<":
            currentComment!.append("<")
            return tokenizeComment()
        case let c:
            reconsume(c)
            state = .comment
            return tokenizeComment()
        }
    }
    
    mutating func tokenizeCommentLessThanSignBang() -> Token? {
        switch nextChar() {
        case "-":
            state = .commentLessThanSignBangDash
            return tokenizeCommentLessThanSignBangDash()
        case let c:
            reconsume(c)
            state = .comment
            return tokenizeComment()
        }
    }
    
    mutating func tokenizeCommentLessThanSignBangDash() -> Token? {
        switch nextChar() {
        case "-":
            state = .commentLessThanSignBangDashDash
            return tokenizeCommentLessThanSignBangDashDash()
        case let c:
            reconsume(c)
            state = .commentEndDash
            return tokenizeCommentEndDash()
        }
    }
    
    mutating func tokenizeCommentLessThanSignBangDashDash() -> Token? {
        let c = nextChar()
        switch c {
        case ">", nil:
            reconsume(c)
            state = .commentEnd
            return tokenizeCommentEnd()
        default:
            // parse error: nested-comment
            reconsume(c)
            state = .commentEnd
            return tokenizeCommentEnd()
        }
    }
    
    mutating func tokenizeCommentEndDash() -> Token? {
        switch nextChar() {
        case "-":
            state = .commentEnd
            return tokenizeCommentEnd()
        case nil:
            // parse error: eof-in-comment
            state = .endOfFile
            return takeCurrentToken()
        case let c:
            currentComment!.append("-")
            reconsume(c)
            state = .comment
            return tokenizeComment()
        }
    }
    
    mutating func tokenizeCommentEnd() -> Token? {
        switch nextChar() {
        case ">":
            state = .data
            return takeCurrentToken()
        case "!":
            state = .commentEndBang
            return tokenizeCommentEndBang()
        case "-":
            currentComment!.append("-")
            return tokenizeCommentEnd()
        case nil:
            // parse error: eof-in-comment
            state = .endOfFile
            return takeCurrentToken()
        case .some(let c):
            currentComment!.append("--")
            reconsume(c)
            state = .comment
            return tokenizeComment()
        }
    }
    
    mutating func tokenizeCommentEndBang() -> Token? {
        switch nextChar() {
        case "-":
            currentComment!.append("--!")
            state = .commentEndDash
            return tokenizeCommentEndDash()
        case ">":
            // parse error: incorrectly-closed-comment
            state = .data
            return takeCurrentToken()
        case nil:
            // parse error: eof-in-comment
            state = .endOfFile
            return takeCurrentToken()
        case .some(let c):
            currentComment!.append("--!")
            reconsume(c)
            state = .comment
            return tokenizeComment()
        }
    }
    
    mutating func tokenizeDoctype() -> Token? {
        switch nextChar() {
        case "\t", "\n", "\u{000C}", " ":
            state = .beforeDoctypeName
            return tokenizeBeforeDoctypeName()
        case ">":
            reconsume(">")
            state = .beforeDoctypeName
            return tokenizeBeforeDoctypeName()
        case nil:
            // parse error: eof-in-doctype
            state = .endOfFile
            return .doctype("", forceQuirks: true, publicIdentifier: nil, systemIdentifier: nil)
        case .some(let c):
            // parse error: missing-whitespace-before-doctype-name
            reconsume(c)
            state = .beforeDoctypeName
            return tokenizeBeforeDoctypeName()
        }
    }
    
    mutating func tokenizeBeforeDoctypeName() -> Token? {
        switch nextChar() {
        case "\t", "\n", "\u{000C}", " ":
            // ignore the character
            return tokenizeBeforeDoctypeName()
        case .some(let c) where ("A"..."Z").contains(c):
            currentDoctype = ("\(c.asciiLowercase)", forceQuirks: false, publicIdentifier: nil, systemIdentifier: nil)
            state = .doctypeName
            return tokenizeDoctypeName()
        case "\0":
            // parse error: unexpected-null-character
            currentDoctype = ("\u{FFFD}", forceQuirks: false, publicIdentifier: nil, systemIdentifier: nil)
            state = .doctypeName
            return tokenizeDoctypeName()
        case ">":
            // parse error: missing-doctype-name
            state = .data
            return .doctype("", forceQuirks: true, publicIdentifier: nil, systemIdentifier: nil)
        case nil:
            // parse error: eof-in-doctype
            state = .endOfFile
            return .doctype("", forceQuirks: false, publicIdentifier: nil, systemIdentifier: nil)
        case .some(let c):
            currentDoctype = ("\(c)", forceQuirks: false, publicIdentifier: nil, systemIdentifier: nil)
            state = .doctypeName
            return tokenizeDoctypeName()
        }
    }
    
    mutating func tokenizeDoctypeName() -> Token? {
        switch nextChar() {
        case "\t", "\n", "\u{000C}", " ":
            state = .afterDoctypeName
            return tokenizeAfterDoctypeName()
        case ">":
            state = .data
            return takeCurrentToken()
        case nil:
            // parse error: eof-in-doctype
            currentDoctype!.forceQuirks = true
            return takeCurrentToken()
        case .some(var c):
            if c == "\0" {
                c = "\u{FFFD}"
            } else if ("A"..."Z").contains(c) {
                c = c.asciiLowercase
            }
            currentDoctype!.0.unicodeScalars.append(c)
            return tokenizeDoctypeName()
        }
    }
    
    mutating func tokenizeAfterDoctypeName() -> Token? {
        switch nextChar() {
        case "\t", "\n", "\u{000C}", " ":
            // ignore the character
            return tokenizeAfterDoctypeName()
        case ">":
            state = .data
            return takeCurrentToken()
        case nil:
            // parse error: eof-in-doctype
            state = .endOfFile
            currentDoctype!.forceQuirks = true
            return takeCurrentToken()
        case .some(let c):
            reconsume(c)
            let peeked = peek(count: 6).lowercased()
            if peeked == "public" {
                consume(count: 6)
                state = .afterDoctypePublicKeyword
                return tokenizeAfterDoctypePublicKeyword()
            } else if peeked == "system" {
                consume(count: 6)
                state = .afterDoctypeSystemKeyword
                return tokenizeAfterDoctypeSystemKeyword()
            } else {
                // parse error: invalid-character-sequence-after-doctype-name
                currentDoctype!.forceQuirks = true
                state = .bogusDoctype
                return tokenizeBogusDoctype()
            }
        }
    }
    
    mutating func tokenizeAfterDoctypePublicKeyword() -> Token? {
        switch nextChar() {
        case "\t", "\n", "\u{000C}", " ":
            state = .beforeDoctypePublicIdentifier
            return tokenizeBeforeDoctypePublicIdentifier()
        case .some(let c) where c == "\"" || c == "'":
            // parse error: missing-whitespace-after-doctype-public-keyword
            currentDoctype!.publicIdentifier = ""
            let quotes = c == "\"" ? DoctypeIdentifierQuotation.doubleQuoted : .singleQuoted
            state = .doctypePublicIdentifier(quotes)
            return tokenizeDoctypePublicIdentifier(quotes: quotes)
        case ">":
            // parse error: missing-doctype-public-identifier
            state = .data
            currentDoctype!.forceQuirks = true
            return takeCurrentToken()
        case nil:
            // parse error: eof-in-doctype
            state = .endOfFile
            currentDoctype!.forceQuirks = true
            return takeCurrentToken()
        case .some(let c):
            // parse error: missing-quote-before-doctype-public-identifier
            currentDoctype!.forceQuirks = true
            state = .bogusDoctype
            reconsume(c)
            return tokenizeBogusDoctype()
        }
    }
    
    mutating func tokenizeBeforeDoctypePublicIdentifier() -> Token? {
        switch nextChar() {
        case "\t", "\n", "\u{000C}", " ":
            // ignore the character
            return tokenizeBeforeDoctypePublicIdentifier()
        case .some(let c) where c == "\"" || c == "'":
            currentDoctype!.publicIdentifier = ""
            let quotes = c == "\"" ? DoctypeIdentifierQuotation.doubleQuoted : .singleQuoted
            state = .doctypePublicIdentifier(quotes)
            return tokenizeDoctypePublicIdentifier(quotes: quotes)
        case ">":
            // parse error: missing-doctype-public-identifier
            state = .data
            currentDoctype!.forceQuirks = true
            return takeCurrentToken()
        case nil:
            // parse error: eof-in-doctype
            state = .endOfFile
            currentDoctype!.forceQuirks = true
            return takeCurrentToken()
        case .some(let c):
            // parse error: missing-quote-before-doctype-public-identifier
            currentDoctype!.forceQuirks = true
            reconsume(c)
            state = .bogusDoctype
            return tokenizeBogusDoctype()
        }
    }
    
    mutating func tokenizeDoctypePublicIdentifier(quotes: DoctypeIdentifierQuotation) -> Token? {
        switch nextChar() {
        case "\"" where quotes == .doubleQuoted:
            state = .afterDoctypePublicIdentifier
            return tokenizeAfterDoctypePublicIdentifier()
        case "'" where quotes == .singleQuoted:
            state = .afterDoctypePublicIdentifier
            return tokenizeAfterDoctypePublicIdentifier()
        case ">":
            // parse error: abrupt-doctype-public-identifier
            reconsume(">")
            state = .data
            currentDoctype!.forceQuirks = true
            return takeCurrentToken()
        case nil:
            // parse error: eof-in-doctype
            state = .endOfFile
            currentDoctype!.forceQuirks = true
            return takeCurrentToken()
        case .some(var c):
            if c == "\0" {
                // parse error: unexpected-null-character
                c = "\u{FFFD}"
            }
            currentDoctype!.publicIdentifier!.unicodeScalars.append(c)
            return tokenizeDoctypePublicIdentifier(quotes: quotes)
        }
    }
    
    mutating func tokenizeAfterDoctypePublicIdentifier() -> Token? {
        switch nextChar() {
        case "\t", "\n", "\u{000C}", " ":
            state = .betweenDoctypePublicAndSystemIdentifiers
            return tokenizeBetweenDoctypePublicAndSystemIdentifiers()
        case ">":
            state = .data
            return takeCurrentToken()
        case .some(let c) where c == "\"" || c == "'":
            // parse error: missing-whitespace-between-doctype-public-and-system-identifiers
            currentDoctype!.systemIdentifier = ""
            let quotes = c == "\"" ? DoctypeIdentifierQuotation.doubleQuoted : .singleQuoted
            state = .doctypeSystemIdentifier(quotes)
            return tokenizeDoctypeSystemIdentifier(quotes: quotes)
        case nil:
            // parse error: eof-in-doctype
            state = .endOfFile
            currentDoctype!.forceQuirks = true
            return takeCurrentToken()
        case .some(let c):
            // parse error: missing-quote-before-doctype-system-identifier
            currentDoctype!.forceQuirks = true
            reconsume(c)
            state = .bogusDoctype
            return tokenizeBogusDoctype()
        }
    }
    
    mutating func tokenizeBetweenDoctypePublicAndSystemIdentifiers() -> Token? {
        switch nextChar() {
        case "\t", "\n", "\u{000C}", " ":
            // ignore the character
            return tokenizeBetweenDoctypePublicAndSystemIdentifiers()
        case ">":
            state = .data
            return takeCurrentToken()
        case .some(let c) where c == "\"" || c == "'":
            currentDoctype!.systemIdentifier = ""
            let quotes = c == "\"" ? DoctypeIdentifierQuotation.doubleQuoted : .singleQuoted
            state = .doctypeSystemIdentifier(quotes)
            return tokenizeDoctypeSystemIdentifier(quotes: quotes)
        case nil:
            // parse error: eof-in-doctype
            state = .endOfFile
            currentDoctype!.forceQuirks = true
            return takeCurrentToken()
        case .some(let c):
            // parse error: missing-quote-before-doctype-system-identifier
            currentDoctype!.forceQuirks = true
            reconsume(c)
            state = .bogusComment
            return tokenizeBogusComment()
        }
    }
    
    mutating func tokenizeAfterDoctypeSystemKeyword() -> Token? {
        switch nextChar() {
        case "\t", "\n", "\u{000C}", " ":
            state = .beforeDoctypeSystemIdentifier
            return tokenizeBeforeDoctypeSystemIdentifier()
        case .some(let c) where c == "\"" || c == "'":
            currentDoctype!.systemIdentifier = ""
            let quotes = c == "\"" ? DoctypeIdentifierQuotation.doubleQuoted : .singleQuoted
            state = .doctypeSystemIdentifier(quotes)
            return tokenizeDoctypeSystemIdentifier(quotes: quotes)
        case ">":
            // parse error: missing-doctype-system-identifier
            state = .data
            currentDoctype!.forceQuirks = true
            return takeCurrentToken()
        case nil:
            // parse error: eof-in-doctype:
            state = .endOfFile
            currentDoctype!.forceQuirks = true
            return takeCurrentToken()
        case .some(let c):
            // parse error: missing-quote-before-doctype-system-identifier
            currentDoctype!.forceQuirks = true
            reconsume(c)
            state = .bogusDoctype
            return tokenizeBogusDoctype()
        }
    }
    
    mutating func tokenizeBeforeDoctypeSystemIdentifier() -> Token? {
        switch nextChar() {
        case "\t", "\n", "\u{000C}", " ":
            // ignore the character
            return tokenizeBeforeDoctypeSystemIdentifier()
        case .some(let c) where c == "\"" || c == "'":
            currentDoctype!.systemIdentifier = ""
            let quotes = c == "\"" ? DoctypeIdentifierQuotation.doubleQuoted : .singleQuoted
            state = .doctypeSystemIdentifier(quotes)
            return tokenizeDoctypeSystemIdentifier(quotes: quotes)
        case ">":
            // parse error: missing-doctype-system-identifier
            state = .data
            currentDoctype!.forceQuirks = true
            return takeCurrentToken()
        case nil:
            // parse error: eof-in-doctype:
            state = .endOfFile
            currentDoctype!.forceQuirks = true
            return takeCurrentToken()
        case .some(let c):
            // parse error: missing-quote-before-doctype-system-identifier
            currentDoctype!.forceQuirks = true
            reconsume(c)
            state = .bogusDoctype
            return tokenizeBogusDoctype()
        }
    }
    
    mutating func tokenizeDoctypeSystemIdentifier(quotes: DoctypeIdentifierQuotation) -> Token? {
        switch nextChar() {
        case "\"" where quotes == .doubleQuoted:
            state = .afterDoctypeSystemIdentifier
            return tokenizeAfterDoctypeSystemIdentifier()
        case "'" where quotes == .singleQuoted:
            state = .afterDoctypeSystemIdentifier
            return tokenizeAfterDoctypeSystemIdentifier()
        case ">":
            // parse error: abrupt-doctype-system-identifier
            state = .data
            currentDoctype!.forceQuirks = true
            return takeCurrentToken()
        case nil:
            // parse error: eof-in-doctype
            state = .endOfFile
            currentDoctype!.forceQuirks = true
            return takeCurrentToken()
        case .some(var c):
            if c == "\0" {
                // parse error: unexpected-null-character
                c = "\u{FFFD}"
            }
            currentDoctype!.systemIdentifier!.unicodeScalars.append(c)
            return tokenizeDoctypeSystemIdentifier(quotes: quotes)
        }
    }
    
    mutating func tokenizeAfterDoctypeSystemIdentifier() -> Token? {
        switch nextChar() {
        case "\t", "\n", "\u{000C}", " ":
            // ignore the character
            return tokenizeAfterDoctypeSystemIdentifier()
        case ">":
            state = .data
            return takeCurrentToken()
        case nil:
            // parse error: eof-in-doctype
            state = .endOfFile
            currentDoctype!.forceQuirks = true
            return takeCurrentToken()
        case .some(let c):
            // parse error: unexpected-character-after-doctype-system-identifier
            // Note: This does not set the current DOCTYPE token's force-quirks flag to on.
            reconsume(c)
            state = .bogusDoctype
            return tokenizeBogusDoctype()
        }
    }
    
    mutating func tokenizeBogusDoctype() -> Token? {
        switch nextChar() {
        case ">":
            state = .data
            return takeCurrentToken()
        case "\0":
            // parse error: unexpected-null-character, ignore the character
            return tokenizeBogusDoctype()
        case nil:
            state = .endOfFile
            return takeCurrentToken()
        case _:
            // ignore the character
            return tokenizeBogusDoctype()
        }
    }
}

private extension Array {
    // Optimization: allows in-place modification of the last element of the array.
    var uncheckedLast: Element {
        _read {
            yield self[count - 1]
        }
        _modify {
            yield &self[count - 1]
        }
    }
}

private extension Unicode.Scalar {
    var asciiLowercase: Unicode.Scalar {
        assert(("A"..."Z").contains(self))
        return Unicode.Scalar(value + 0x20)!
    }
    
    var hexDigitValue: Int? {
        switch self {
        case "0": 0
        case "1": 1
        case "2": 2
        case "3": 3
        case "4": 4
        case "5": 5
        case "6": 6
        case "7": 7
        case "8": 8
        case "9": 9
        case "A", "a": 0xA
        case "B", "b": 0xB
        case "C", "c": 0xC
        case "D", "d": 0xD
        case "E", "e": 0xE
        case "F", "f": 0xF
        default: nil
        }
    }
    
    var isNumber: Bool {
        ("0"..."9").contains(self)
    }
}
//swiftlint: enable all
