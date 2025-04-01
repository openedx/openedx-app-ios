import Foundation

//swiftlint: disable all
public class BlockStateMachine {
    private enum BlockState {
        case normal
        case preformatted
    }
    
    private let blockBreak: String
    private let lineBreak: String
    private let listIndentForContentOutsideItem: String
    private let append: (String) -> Void
    private let removeChar: () -> Void
    
    private var pendingBlockEnd = false
    private var pendingNewlineCount = 0
    private var inListItem = false
    private var state: BlockState = .normal
    
    init(blockBreak: String, lineBreak: String, listIndentForContentOutsideItem: String, append: @escaping (String) -> Void, removeChar: @escaping () -> Void) {
        self.blockBreak = blockBreak
        self.lineBreak = lineBreak
        self.listIndentForContentOutsideItem = listIndentForContentOutsideItem
        self.append = append
        self.removeChar = removeChar
    }
    
    func startOrEndBlock() {
        if pendingBlockEnd {
            // If we already have a block end pending, that means this
            // current block start is a no-op.
            pendingBlockEnd = false
            return
        }
        pendingBlockEnd = true
    }
    
    func endBlocks() {
        if pendingBlockEnd && !pendingNewlineCount.isModZero(2) {
            append(blockBreak)
        }
    }
    
    func breakTag() {
        append(lineBreak)
        pendingNewlineCount += 1
    }
    
    func startPreformatted() {
        state = .preformatted
    }
    
    func endPreformatted() {
        state = .normal
    }
    
    func startListItem() {
        inListItem = true
    }
    
    func endListItem() {
        inListItem = false
        pendingNewlineCount = 0
    }
    
    func continueBlock(char c: UnicodeScalar) -> Bool {
        // We allow all chars except for linebreaks to proceed without interrupting blocks
        if c != "\n" && c != "\r" {
            // We might have a pending block end
            if pendingBlockEnd {
                append(blockBreak)
                pendingBlockEnd = false
                pendingNewlineCount = 0
            }
            // If we have newlines that haven't been converted to blocks
            // (i.e., are in the middle of a block), convert them to the appropriate break
            if pendingNewlineCount > 0 {
                if state == .preformatted {
                    for _ in 0..<pendingNewlineCount {
                        append(lineBreak)
                    }
                } else if pendingNewlineCount.isModZero(2) {
                    append(blockBreak)
                } else {
                    append(lineBreak)
                }
                pendingNewlineCount = 0
            }
            return true
        }
        
        // Handle linebreaks, which may or may not interrupt blocks
        if c == "\r" {
            return false
        }
        
        // \n linebreaks
        pendingNewlineCount += 1
        
        if state == .preformatted {
            // In preformatted text, linebreaks are preserved
            append(lineBreak)
            pendingNewlineCount = 0
            return false
        }
        
        // In normal text, linebreaks depend on the context of surrounding blocks
        if pendingNewlineCount == 2 {
            // Two consecutive newlines = end of paragraph
            if pendingBlockEnd {
                // This is an empty block, clear the state
                pendingBlockEnd = false
                pendingNewlineCount = 0
            } else {
                pendingBlockEnd = true
            }
            return false
        }
        
        // One newline is not significant, it's just space
        return false
    }
}

extension Int {
    fileprivate func isModZero(_ mod: Int) -> Bool {
        self % mod == 0
    }
}
//swiftlint: enable all 