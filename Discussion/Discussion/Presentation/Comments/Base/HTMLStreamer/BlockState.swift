//
//  BlockState.swift
//  HTMLStreamer
//
//  Created by Shadowfacts on 2/14/24.
//

import Foundation
import OEXFoundation

/*
 
 This gnarly mess of a state machine is responsible for:
 1) Inserting line breaks in the right places corresponding to boundaries between block elements
 2) Preventing leading/trailing whitespace from being emitted
 3) Handling whitespace inside <pre> elements
 
 DO NOT TOUCH THE CODE WITHOUT CHECKING/UPDATING THE DIAGRAM.

 */

struct BlockStateMachine {
    #if false
    var blockState: BlockState = .start {
        didSet {
            print("\(oldValue) -> \(blockState)")
        }
    }
    #else
    var blockState: BlockState = .start
    #endif
    let blockBreak: String
    let lineBreak: String
    let listIndentForContentOutsideItem: String
    var temporaryBuffer: String = ""
    let append: (String) -> Void
    let removeChar: () -> Void
}

extension BlockStateMachine {
    mutating func startOrEndBlock() {
        switch blockState {
        case .start:
            break
        case .emptyBlock:
            break
        case .nonEmptyBlock:
            blockState = .emptyBlock
        case .lineBreakTag:
            blockState = .emptyBlock
            temporaryBuffer = ""
        case .atLeastTwoLineBreakTags:
            blockState = .emptyBlockWithAtLeastTwoPreviousLineBreakTags
        case .emptyBlockWithAtLeastTwoPreviousLineBreakTags:
            break
        case .beginListItem:
            break
        case .endListItem:
            blockState = .emptyBlock
        case .listItemContent:
            blockState = .emptyBlock
        case .lineBreakTagInListItemContent:
            blockState = .emptyBlock
            temporaryBuffer = ""
        case .atLeastTwoLineBreakTagsInListItemContent:
            blockState = .emptyBlockWithAtLeastTwoPreviousLineBreakTags
        case .preformattedStart:
            break
        case .preformattedEmptyBlock:
            break
        case .preformattedNonEmptyBlock(let depth):
            blockState = .preformattedEmptyBlock(depth: depth)
        case .preformattedLineBreak(depth: let depth):
            blockState = .preformattedEmptyBlockWithLeadingWhitespace(depth: depth)
            temporaryBuffer.append(lineBreak)
        case .preformattedAtLeastTwoLineBreaks(let depth):
            blockState = .preformattedEmptyBlockWithLeadingWhitespace(depth: depth)
        case .afterPreStartTag(let depth):
            blockState = .preformattedEmptyBlock(depth: depth)
        case .afterPreStartTagWithLeadingWhitespace(let depth):
            blockState = .preformattedEmptyBlockWithLeadingWhitespace(depth: depth)
        case .preformattedNonEmptyBlockWithTrailingWhitespace(let depth):
            blockState = .preformattedEmptyBlockWithLeadingWhitespace(depth: depth)
            temporaryBuffer.append(blockBreak)
        case .preformattedEmptyBlockWithLeadingWhitespace:
            break
        }
    }
    
    //swiftlint: disable function_body_length
    mutating func continueBlock(char: UnicodeScalar) -> Bool {
        let isNewline = char == "\n"
        let isWhitespace = isNewline || isWhitespace(char)
        switch blockState {
        case .start:
            if isWhitespace {
                return false
            } else {
                blockState = .nonEmptyBlock
                return true
            }
        case .emptyBlock:
            if isWhitespace {
                return false
            } else {
                blockState = .nonEmptyBlock
                append(blockBreak)
                return true
            }
        case .nonEmptyBlock:
            if isNewline {
                blockState = .lineBreakTag
                temporaryBuffer.append("\n")
                return false
            } else {
                return true
            }
        case .lineBreakTag:
            if isWhitespace {
                if isNewline {
                    blockState = .atLeastTwoLineBreakTags
                }
                temporaryBuffer.unicodeScalars.append(char)
                return false
            } else {
                blockState = .nonEmptyBlock
                append(temporaryBuffer)
                temporaryBuffer = ""
                return true
            }
        case .atLeastTwoLineBreakTags:
            if isWhitespace {
                temporaryBuffer.unicodeScalars.append(char)
                return false
            } else {
                blockState = .nonEmptyBlock
                append(temporaryBuffer)
                temporaryBuffer = ""
                return true
            }
        case .emptyBlockWithAtLeastTwoPreviousLineBreakTags:
            if isWhitespace {
                return false
            } else {
                blockState = .nonEmptyBlock
                append(temporaryBuffer)
                temporaryBuffer = ""
                return true
            }
        case .beginListItem:
            if isWhitespace {
                return false
            } else {
                blockState = .listItemContent
                return true
            }
        case .endListItem:
            if isWhitespace {
                return false
            } else {
                blockState = .listItemContent
                append(lineBreak)
                append(listIndentForContentOutsideItem)
                return true
            }
        case .listItemContent:
            if isNewline {
                blockState = .lineBreakTagInListItemContent
                temporaryBuffer.append("\n")
                return false
            } else {
                return true
            }
        case .lineBreakTagInListItemContent:
            if isWhitespace {
                if isNewline {
                    blockState = .atLeastTwoLineBreakTagsInListItemContent
                }
                temporaryBuffer.unicodeScalars.append(char)
                return false
            } else {
                blockState = .listItemContent
                append(temporaryBuffer)
                temporaryBuffer = ""
                return true
            }
        case .atLeastTwoLineBreakTagsInListItemContent:
            if isWhitespace {
                temporaryBuffer.unicodeScalars.append(char)
                return false
            } else {
                blockState = .listItemContent
                append(temporaryBuffer)
                temporaryBuffer = ""
                return true
            }
        case .preformattedStart(let depth):
            if isNewline {
                return false
            } else {
                blockState = .preformattedNonEmptyBlock(depth: depth)
                return true
            }
        case .preformattedEmptyBlock(depth: let depth):
            if isWhitespace {
                blockState = .preformattedEmptyBlockWithLeadingWhitespace(depth: depth)
                temporaryBuffer.unicodeScalars.append(char)
                return false
            } else {
                blockState = .preformattedNonEmptyBlock(depth: depth)
                append(blockBreak)
                return true
            }
        case .preformattedNonEmptyBlock(let depth):
            if isNewline {
                blockState = .preformattedLineBreak(depth: depth)
                temporaryBuffer.append(lineBreak)
                return false
            } else if isWhitespace {
                blockState = .preformattedNonEmptyBlockWithTrailingWhitespace(depth: depth)
                temporaryBuffer.unicodeScalars.append(char)
                return false
            } else {
                return true
            }
        case .preformattedLineBreak(let depth):
            if isNewline {
                blockState = .preformattedAtLeastTwoLineBreaks(depth: depth)
                temporaryBuffer.append(lineBreak)
                return false
            } else if isWhitespace {
                blockState = .preformattedNonEmptyBlockWithTrailingWhitespace(depth: depth)
                temporaryBuffer.unicodeScalars.append(char)
                return false
            } else {
                blockState = .preformattedNonEmptyBlock(depth: depth)
                append(temporaryBuffer)
                temporaryBuffer = ""
                return true
            }
        case .preformattedAtLeastTwoLineBreaks(let depth):
            if isWhitespace {
                temporaryBuffer.unicodeScalars.append(char)
                return false
            } else {
                blockState = .preformattedNonEmptyBlock(depth: depth)
                append(temporaryBuffer)
                temporaryBuffer = ""
                return true
            }
        case .afterPreStartTag(let depth):
            if isNewline {
                blockState = .preformattedEmptyBlock(depth: depth)
                return false
            } else {
                blockState = .preformattedNonEmptyBlock(depth: depth)
                append(blockBreak)
                return true
            }
        case .afterPreStartTagWithLeadingWhitespace(let depth):
            if isNewline {
                blockState = .preformattedEmptyBlockWithLeadingWhitespace(depth: depth)
                return false
            } else if isWhitespace {
                blockState = .preformattedEmptyBlockWithLeadingWhitespace(depth: depth)
                temporaryBuffer.unicodeScalars.append(char)
                return false
            } else {
                blockState = .preformattedNonEmptyBlock(depth: depth)
                append(temporaryBuffer)
                temporaryBuffer = ""
                return true
            }
        case .preformattedNonEmptyBlockWithTrailingWhitespace(let depth):
            if isNewline {
                blockState = .preformattedLineBreak(depth: depth)
                temporaryBuffer.append(lineBreak)
                return false
            } else if isWhitespace {
                temporaryBuffer.unicodeScalars.append(char)
                return false
            } else {
                blockState = .preformattedNonEmptyBlock(depth: depth)
                append(temporaryBuffer)
                temporaryBuffer = ""
                return true
            }
        case .preformattedEmptyBlockWithLeadingWhitespace(let depth):
            if isNewline {
                blockState = .preformattedLineBreak(depth: depth)
                temporaryBuffer.append(lineBreak)
                return false
            } else if isWhitespace {
                temporaryBuffer.unicodeScalars.append(char)
                return false
            } else {
                blockState = .preformattedNonEmptyBlock(depth: depth)
                append(temporaryBuffer)
                temporaryBuffer = ""
                return true
            }
        }
    }
    //swiftlint: enable function_body_length
    
    mutating func breakTag() {
        switch blockState {
        case .start:
            break
        case .emptyBlock:
            blockState = .lineBreakTag
            append(blockBreak)
            temporaryBuffer.append(lineBreak)
        case .nonEmptyBlock:
            blockState = .lineBreakTag
            temporaryBuffer.append(lineBreak)
        case .lineBreakTag:
            blockState = .atLeastTwoLineBreakTags
            temporaryBuffer.append(lineBreak)
        case .atLeastTwoLineBreakTags:
            temporaryBuffer.append(lineBreak)
        case .emptyBlockWithAtLeastTwoPreviousLineBreakTags:
            append(lineBreak)
        case .beginListItem:
            append(lineBreak)
        case .endListItem:
            blockState = .lineBreakTagInListItemContent
            temporaryBuffer.append(lineBreak)
        case .listItemContent:
            blockState = .lineBreakTagInListItemContent
            temporaryBuffer.append(lineBreak)
        case .lineBreakTagInListItemContent:
            blockState = .atLeastTwoLineBreakTagsInListItemContent
            temporaryBuffer.append(lineBreak)
        case .atLeastTwoLineBreakTagsInListItemContent:
            temporaryBuffer.append(lineBreak)
        case .preformattedStart:
            break
        case .preformattedEmptyBlock(let depth):
            blockState = .preformattedLineBreak(depth: depth)
            temporaryBuffer.append(lineBreak)
        case .preformattedNonEmptyBlock(let depth):
            blockState = .preformattedLineBreak(depth: depth)
            temporaryBuffer.append(lineBreak)
        case .preformattedLineBreak(let depth):
            blockState = .preformattedAtLeastTwoLineBreaks(depth: depth)
            temporaryBuffer.append(lineBreak)
        case .preformattedAtLeastTwoLineBreaks:
            temporaryBuffer.append(lineBreak)
        case .afterPreStartTag(let depth):
            blockState = .preformattedLineBreak(depth: depth)
            temporaryBuffer.append(blockBreak)
            temporaryBuffer.append(lineBreak)
        case .afterPreStartTagWithLeadingWhitespace(let depth):
            blockState = .preformattedEmptyBlockWithLeadingWhitespace(depth: depth)
            temporaryBuffer.append(lineBreak)
        case .preformattedNonEmptyBlockWithTrailingWhitespace(let depth):
            blockState = .preformattedLineBreak(depth: depth)
            temporaryBuffer.append(lineBreak)
        case .preformattedEmptyBlockWithLeadingWhitespace(let depth):
            blockState = .preformattedLineBreak(depth: depth)
            temporaryBuffer.append(lineBreak)
        }
    }
    
    mutating func startPreformatted() {
        switch blockState {
        case .start:
            blockState = .preformattedStart(depth: 1)
        case .emptyBlock:
            blockState = .afterPreStartTag(depth: 1)
        case .nonEmptyBlock:
            debugLog("nonEmptyBlock unreachable")
        case .lineBreakTag:
            debugLog("lineBreakTag unreachable")
        case .atLeastTwoLineBreakTags:
            debugLog("atLeastTwoLineBreakTags unreachable")
        case .emptyBlockWithAtLeastTwoPreviousLineBreakTags:
            blockState = .afterPreStartTagWithLeadingWhitespace(depth: 1)
        case .beginListItem:
            blockState = .afterPreStartTagWithLeadingWhitespace(depth: 1)
        case .endListItem:
            debugLog("endListItem unreachable")
        case .listItemContent:
            debugLog("listItemContent unreachable")
        case .lineBreakTagInListItemContent:
            debugLog("lineBreakTagInListItemContent unreachable")
        case .atLeastTwoLineBreakTagsInListItemContent:
            debugLog("atLeastTwoLineBreakTagsInListItemContent unreachable")
        case .preformattedStart(let depth):
            blockState = .preformattedStart(depth: depth + 1)
        case .preformattedEmptyBlock(let depth):
            blockState = .afterPreStartTag(depth: depth + 1)
        case .preformattedNonEmptyBlock:
            debugLog("preformattedNonEmptyBlock unreachable")
        case .preformattedLineBreak:
            debugLog("preformattedLineBreak unreachable")
        case .preformattedAtLeastTwoLineBreaks:
            debugLog("preformattedAtLeastTwoLineBreaks unreachable")
        case .afterPreStartTag:
            debugLog("afterPreStartTag unreachable")
        case .afterPreStartTagWithLeadingWhitespace:
            debugLog("afterPreStartTagWithLeadingWhitespace unreachable")
        case .preformattedNonEmptyBlockWithTrailingWhitespace:
            debugLog("preformattedNonEmptyBlockWithTrailingWhitespace unreachable")
        case .preformattedEmptyBlockWithLeadingWhitespace(let depth):
            blockState = .afterPreStartTagWithLeadingWhitespace(depth: depth + 1)
        }
    }
    
    mutating func endPreformatted() {
        switch blockState {
        case .start:
            break
        case .emptyBlock:
            break
        case .nonEmptyBlock:
            debugLog("nonEmptyBlock unreachable")
        case .lineBreakTag:
            debugLog("lineBreakTag unreachable")
        case .atLeastTwoLineBreakTags:
            debugLog("atLeastTwoLineBreakTags unreachable")
        case .emptyBlockWithAtLeastTwoPreviousLineBreakTags:
            break
        case .beginListItem:
            break
        case .endListItem:
            debugLog("endListItem unreachable")
        case .listItemContent:
            debugLog("listItemContent unreachable")
        case .lineBreakTagInListItemContent:
            debugLog("lineBreakTagInListItemContent unreachable")
        case .atLeastTwoLineBreakTagsInListItemContent:
            debugLog("atLeastTwoLineBreakTagsInListItemContent unreachable")
        case .preformattedStart(let depth):
            if depth <= 1 {
                blockState = .start
            } else {
                blockState = .preformattedStart(depth: depth - 1)
            }
        case .preformattedEmptyBlock(let depth):
            if depth <= 1 {
                blockState = .emptyBlock
            } else {
                blockState = .preformattedEmptyBlock(depth: depth - 1)
            }
        case .preformattedNonEmptyBlock:
            debugLog("preformattedNonEmptyBlock unreachable")
        case .preformattedLineBreak:
            debugLog("preformattedLineBreak unreachable")
        case .preformattedAtLeastTwoLineBreaks:
            debugLog("preformattedAtLeastTwoLineBreaks unreachable")
        case .afterPreStartTag:
            debugLog("afterPreStartTag unreachable")
        case .afterPreStartTagWithLeadingWhitespace:
            debugLog("afterPreStartTagWithLeadingWhitespace unreachable")
        case .preformattedNonEmptyBlockWithTrailingWhitespace:
            debugLog("preformattedNonEmptyBlockWithTrailingWhitespace unreachable")
        case .preformattedEmptyBlockWithLeadingWhitespace(let depth):
            if depth <= 1 {
                blockState = .emptyBlock
                temporaryBuffer = ""
            } else {
                if temporaryBuffer.count >= 2 {
                    temporaryBuffer.removeLast()
                    blockState = .preformattedEmptyBlockWithLeadingWhitespace(depth: depth - 1)
                } else {
                    temporaryBuffer.removeLast()
                    blockState = .preformattedEmptyBlock(depth: depth - 1)
                }
            }
        }
    }
    
    mutating func startListItem() {
        switch blockState {
        case .start:
            blockState = .beginListItem
        case .emptyBlock:
            blockState = .beginListItem
            append(blockBreak)
        case .nonEmptyBlock:
            blockState = .beginListItem
            append(blockBreak)
        case .beginListItem:
            break
        case .endListItem:
            blockState = .beginListItem
            append(lineBreak)
        case .listItemContent:
            blockState = .beginListItem
            append(lineBreak)
        case .lineBreakTagInListItemContent:
            blockState = .beginListItem
            append(temporaryBuffer)
            temporaryBuffer = ""
            append(lineBreak)
        case .atLeastTwoLineBreakTagsInListItemContent:
            blockState = .beginListItem
            append(temporaryBuffer)
            temporaryBuffer = ""
            append(lineBreak)
        default:
            break
        }
    }
    
    mutating func endListItem() {
        switch blockState {
        case .emptyBlock:
            blockState = .endListItem
        case .nonEmptyBlock:
            blockState = .endListItem
        case .listItemContent:
            blockState = .endListItem
        case .lineBreakTagInListItemContent:
            blockState = .endListItem
            temporaryBuffer = ""
        case .atLeastTwoLineBreakTagsInListItemContent:
            blockState = .endListItem
            temporaryBuffer = ""
        default:
            break
        }
    }
    
    mutating func endBlocks() {
        switch blockState {
        default:
            break
        }
    }
}

enum BlockState: Equatable {
    case start
    case emptyBlock
    case nonEmptyBlock
    case lineBreakTag
    case atLeastTwoLineBreakTags
    case emptyBlockWithAtLeastTwoPreviousLineBreakTags
    case beginListItem
    case endListItem
    case listItemContent
    case lineBreakTagInListItemContent
    case atLeastTwoLineBreakTagsInListItemContent
    case preformattedStart(depth: Int32)
    case preformattedEmptyBlock(depth: Int32)
    case preformattedNonEmptyBlock(depth: Int32)
    case preformattedLineBreak(depth: Int32)
    case preformattedAtLeastTwoLineBreaks(depth: Int32)
    case afterPreStartTag(depth: Int32)
    case afterPreStartTagWithLeadingWhitespace(depth: Int32)
    case preformattedNonEmptyBlockWithTrailingWhitespace(depth: Int32)
    case preformattedEmptyBlockWithLeadingWhitespace(depth: Int32)
}

@inline(__always)
private func isWhitespace(_ c: UnicodeScalar) -> Bool {
    // this is not strictly correct, but checking the actual unicode properties is slow
    // and this should cover the vast majority of actual use
    c == " " || c == "\n" || c == "\t"
}
