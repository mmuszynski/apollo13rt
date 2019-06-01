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
    
}
