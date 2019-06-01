//
//  Transcript.swift
//  Apollo13Realtime
//
//  Created by Mike Muszynski on 5/30/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation

struct Transcript {
    var elements: [Element]
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        self.elements = try decoder.decode(Array<TranscriptEntry>.self, from: data)
    }
    
    func activeIDs(for timeOffset: TimeInterval) -> [Int] {
        let ids = self.filter { (entry) -> Bool in
            guard let time = entry.activeMETRange else { return false }
            return time.contains(timeOffset)
        }.map { $0.id }
        
        return ids
    }
}

extension Transcript: Collection {

    typealias Element = TranscriptEntry
    
    func index(after i: Array<Transcript.Element>.Index) -> Array<Transcript.Element>.Index {
        return elements.index(after: i)
    }
    
    subscript(position: Array<Transcript.Element>.Index) -> TranscriptEntry {
        return elements[position]
    }
    
    var startIndex: Array<Transcript.Element>.Index {
        return elements.startIndex
    }
    
    var endIndex: Array<Transcript.Element>.Index {
        return elements.endIndex
    }
    
}
