//
//  Apollo13RealtimeTests.swift
//  Apollo13RealtimeTests
//
//  Created by Mike Muszynski on 5/29/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import XCTest
@testable import Apollo13Realtime

class Apollo13RealtimeTests: XCTestCase {

    func testDecodingJSON() {
        let bundle = Bundle(for: self.classForCoder)
        let url = bundle.url(forResource: "air-ground-loop", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        let transcripts = try! decoder.decode([TranscriptEntry].self, from: data)
        XCTAssert(!transcripts.isEmpty)
    }
    
    func testAnnotation() {
        let entries = Transcript.airGroundLoop
        let firstAnnotated = entries.first(where: { $0.annotations != nil })
        guard let message = firstAnnotated?.message else {
            XCTFail("Couldn't find any annotated messages")
            return
        }
        
        guard let start = message.firstIndex(of: "{"),
              let end = message.firstIndex(of: "}") else {
            XCTFail("End index before start index")
            return
        }
        
        let annotation = message[start..<end]
        let unchecked = String(message[end...])
        
    }
}
