//
//  HTMLContentFixProcessor.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 3.04.2025.
//

import Foundation

// Class to preprocess HTML and fix issues before processing
public class HTMLContentFixProcessor {
    // Fix list structure to ensure proper nesting levels
    func fixListStructure(_ html: String) -> String {
        let processedHTML = html
        
        do {
            // 1. Add nesting attributes to list elements to assist with proper rendering
            let nestingPattern = #"<(ol|ul)([^>]*)>"#
            let nestingRegex = try NSRegularExpression(pattern: nestingPattern, options: [])
            
            var currentLevel = 0
            var result = ""
            var lastIndex = processedHTML.startIndex
            
            nestingRegex.enumerateMatches(
                in: processedHTML,
                range: NSRange(
                    processedHTML.startIndex..<processedHTML.endIndex,
                    in: processedHTML
                )
            ) { match, _, _ in
                guard let match = match,
                      let range = Range(match.range, in: processedHTML),
                      let tagRange = Range(match.range(at: 1), in: processedHTML),
                      let attrsRange = Range(match.range(at: 2), in: processedHTML) else {
                    return
                }
                
                // Add text before this tag
                if lastIndex < range.lowerBound {
                    result.append(String(processedHTML[lastIndex..<range.lowerBound]))
                }
                
                let tag = processedHTML[tagRange]
                let attrs = processedHTML[attrsRange]
                
                if tag == "ol" || tag == "ul" {
                    // Increase level for start tags
                    currentLevel += 1
                    // Add the tag with data-level attribute
                    result.append("<\(tag)\(attrs) data-level=\"\(currentLevel)\">")
                }
                
                lastIndex = range.upperBound
            }
            
            // Add remainder of string
            if lastIndex < processedHTML.endIndex {
                result.append(String(processedHTML[lastIndex..<processedHTML.endIndex]))
            }
            
            let brPattern = #"(<li[^>]*>.*?)(<br>)(.*?<(?:ol|ul))"#
            let brRegex = try NSRegularExpression(pattern: brPattern, options: [.dotMatchesLineSeparators])
            
            result = brRegex.stringByReplacingMatches(
                in: result,
                options: [],
                range: NSRange(result.startIndex..<result.endIndex, in: result),
                withTemplate: "$1$3"
            )
            
            return result
            
        } catch {
            return html
        }
    }
}
