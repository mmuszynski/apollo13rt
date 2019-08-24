//
//  TranscriptEntry.swift
//  Apollo13Realtime
//
//  Created by Mike Muszynski on 5/29/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import UIKit

//{"id":1,"start":200791,"end":200791,"source":"CAPCOM","line":4,"message":"Thank you, 13."}

struct TranscriptEntry: Codable {
    var id: Int
    var start: Int?
    var end: Int?
    var line: Int
    var source: String
    var message: String
    var annotations: [String]?
    var tokens: [String]?
    
    var usefulEnd: Int? {
        if let trueEnd = end, start != trueEnd { return trueEnd }
        guard let start = start else { return nil }
        return start + 1
    }
    
    var activeMETRange: Range<TimeInterval>? {
        guard let start = self.start else {
            return nil
        }
        
        return TimeInterval(start)..<TimeInterval(usefulEnd!)
    }
    
    var annotatedMessage: NSAttributedString {
        var final = message
        var rangesOfAnnotations: [NSRange] = []
        while let annotationStart = final.firstIndex(of: "{") {
            guard let annotationEnd = final.firstIndex(of: "}") else { continue }
            
            let swiftRange = annotationStart..<final.index(before: annotationEnd)
            let range = NSRange(swiftRange, in: final)
            rangesOfAnnotations.append(range)
            
            final.remove(at: annotationStart)
            final.replaceSubrange(final.index(before: annotationEnd)...final.index(before: annotationEnd), with: "\(rangesOfAnnotations.count)")
        }
        
        let attributed = NSMutableAttributedString(string: final)
        for range in rangesOfAnnotations {
            attributed.addAttribute(.backgroundColor, value: UIColor(white: 0, alpha: 0.25), range: range)
            attributed.addAttribute(.baselineOffset, value: UIFont.smallSystemFontSize / 3, range: NSRange(location: range.upperBound, length: 1))
            attributed.addAttribute(.font, value: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), range: NSRange(location: range.upperBound, length: 1))
        }
        
        return attributed
    }
}
