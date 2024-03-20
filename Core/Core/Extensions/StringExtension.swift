//
//  StringExtension.swift
//  Core
//
//  Created by  Stepanok Ivan on 29.09.2022.
//

import Foundation

public extension String {
    
    func find(from: String, to: String) -> [String] {
        components(separatedBy: from).dropFirst().compactMap { sub in
            (sub.range(of: to)?.lowerBound).flatMap { endRange in
                String(sub[sub.startIndex ..< endRange])
            }
        }
    }
    
    func hideHtmlTagsAndUrls() -> String {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return self
        }
        return detector.stringByReplacingMatches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: self.utf16.count),
            withTemplate: ""
        )
        .replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        .replacingOccurrences(of: "<h2>", with: "")
        .replacingOccurrences(of: "<p>", with: "")
    }
    
    func hideHtmlTags() -> String {
        return self
        .replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
    
    func extractURLs() -> [URL] {
        var urls: [URL] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(
                in: self, options: [],
                range: NSRange(location: 0, length: self.count),
                using: { (result, _, _) in
                    if let match = result, let url = match.url {
                        urls.append(url)
                    }
                }
            )
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return urls
    }

    func decodedHTMLEntities() -> String {
        guard let regex = try? NSRegularExpression(pattern: "&#([0-9]+);", options: []) else {
            return self
        }

        let range = NSRange(location: 0, length: count)
        let matches = regex.matches(in: self, options: [], range: range)
        
        var decodedString = self
        for match in matches {
            guard match.numberOfRanges > 1,
                  let range = Range(match.range(at: 1), in: self),
                  let codePoint = Int(self[range]),
                  let unicodeScalar = UnicodeScalar(codePoint) else {
                continue
            }
            
            let replacement = String(unicodeScalar)
            guard let totalRange = Range(match.range, in: self) else {
                continue
            }
            decodedString = decodedString.replacingOccurrences(of: self[totalRange], with: replacement)
        }
        
        return decodedString
    }
}
