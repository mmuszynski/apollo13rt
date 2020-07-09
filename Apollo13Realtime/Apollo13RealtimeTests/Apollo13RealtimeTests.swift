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
    
    func testAnnotation() {
        let entries = Transcript.airGroundLoop
        let firstAnnotated = entries.first(where: { $0.annotations != nil })
        guard let message = firstAnnotated?.message else {
            XCTFail("Couldn't find any annotated messages")
            return
        }
        
        XCTAssertEqual(firstAnnotated?.messageInParts.count, 3)
    }
    
    func testAnnotationPrecondition() {
        let entries = Transcript.airGroundLoop
        for entry in entries {
            let _ = entry.messageInParts
        }
    }
}
