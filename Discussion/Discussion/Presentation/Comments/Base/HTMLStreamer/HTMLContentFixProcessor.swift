import Foundation

// Class to preprocess HTML and fix issues before processing
//class HTMLContentFixProcessor {
//    // Fix list structure to ensure proper nesting levels
//    func fixListStructure(_ html: String) -> String {
//        print(">>>DEB 🛠️ HTMLContentFixProcessor - fixing list structure")
//        var processedHTML = html
//        
//        // Decode HTML entities for proper display of quotation marks
//        processedHTML = decodeHTMLEntities(processedHTML)
//        
//        do {
//            // 1. Add nesting attributes to list elements to assist with proper rendering
//            let nestingPattern = #"<(ol|ul)([^>]*)>"#
//            let nestingRegex = try NSRegularExpression(pattern: nestingPattern, options: [])
//            
//            var currentLevel = 0
//            var result = ""
//            var lastIndex = processedHTML.startIndex
//            
//            nestingRegex.enumerateMatches(
//                in: processedHTML,
//                range: NSRange(processedHTML.startIndex..<processedHTML.endIndex, in: processedHTML)
//            ) { match, _, _ in
//                guard let match = match,
//                      let range = Range(match.range, in: processedHTML),
//                      let tagRange = Range(match.range(at: 1), in: processedHTML),
//                      let attrsRange = Range(match.range(at: 2), in: processedHTML) else {
//                    return
//                }
//                
//                // Add text before this tag
//                if lastIndex < range.lowerBound {
//                    result.append(String(processedHTML[lastIndex..<range.lowerBound]))
//                }
//                
//                let tag = processedHTML[tagRange]
//                let attrs = processedHTML[attrsRange]
//                
//                if tag == "ol" || tag == "ul" {
//                    // Increase level for start tags
//                    currentLevel += 1
//                    // Add the tag with data-level attribute
//                    result.append("<\(tag)\(attrs) data-level=\"\(currentLevel)\">")
//                }
//                
//                lastIndex = range.upperBound
//            }
//            
//            // Add remainder of string
//            if lastIndex < processedHTML.endIndex {
//                result.append(String(processedHTML[lastIndex..<processedHTML.endIndex]))
//            }
//            
//            // Reset levels when list ends
//            let endPattern = #"</(ol|ul)>"#
//            let endRegex = try NSRegularExpression(pattern: endPattern, options: [])
//            
//            processedHTML = result
//            result = ""
//            lastIndex = processedHTML.startIndex
//            currentLevel = 0
//            
//            endRegex.enumerateMatches(
//                in: processedHTML,
//                range: NSRange(
//                    processedHTML.startIndex..<processedHTML.endIndex,
//                    in: processedHTML
//                )
//            ) { match, _, _ in
//                guard let match = match,
//                      let range = Range(match.range, in: processedHTML),
//                      let tagRange = Range(match.range(at: 1), in: processedHTML) else {
//                    return
//                }
//                
//                // Add text before this tag
//                if lastIndex < range.lowerBound {
//                    result.append(String(processedHTML[lastIndex..<range.lowerBound]))
//                }
//                
//                let tag = processedHTML[tagRange]
//                
//                if tag == "ol" || tag == "ul" {
//                    // Add closing tag
//                    result.append("</\(tag)>")
//                    // Decrease level for end tags
//                    if currentLevel > 0 {
//                        currentLevel -= 1
//                    }
//                }
//                
//                lastIndex = range.upperBound
//            }
//            
//            // Add remainder of string
//            if lastIndex < processedHTML.endIndex {
//                result.append(String(processedHTML[lastIndex..<processedHTML.endIndex]))
//            }
//            
//            print(">>>DEB 🛠️ Fixed HTML structure: \(result.prefix(100))")
//            return result
//            
//        } catch {
//            print(">>>DEB ❌ Error fixing list structure: \(error)")
//            return processedHTML
//        }
//    }
//    
//    // Simple HTML entity decoder for common entities
//    private func decodeHTMLEntities(_ html: String) -> String {
//        var result = html
//        
//        // Common HTML entities
//        let entities: [String: String] = [
//            "&laquo;": "«",
//            "&raquo;": "»",
//            "&quot;": "\"",
//            "&ldquo;": "\"",
//            "&rdquo;": "\"",
//            "&ndash;": "–",
//            "&mdash;": "—",
//            "&amp;": "&",
//            "&lt;": "<",
//            "&gt;": ">",
//            "&nbsp;": " ",
//            "&rsquo;": "'",
//            "&lsquo;": "'"
//        ]
//        
//        for (entity, replacement) in entities {
//            result = result.replacingOccurrences(of: entity, with: replacement)
//        }
//        
//        return result
//    }
//}
