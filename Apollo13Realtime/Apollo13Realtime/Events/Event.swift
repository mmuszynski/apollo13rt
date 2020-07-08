//
//  Event.swift
//  Apollo13Realtime
//
//  Created by Mike Muszynski on 6/4/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation

/*
 
 
 new Timer( start: 204_519, zero: 211_359, end: 206_650, caption: 'Predicted fuel cell depletion', hot: new List([ new Timer( start: 206_648, end: 206_650 ) ]) ),
 new Timer( start: 206_650, zero: 209_050, end: 206_942, caption: 'Predicted fuel cell depletion', hot: new List([ new Timer( start: 206_650, end: 206_654 ), new Timer( start: 206_940, end: 206_943 ) ])
 ),
 new Timer( start: 206942, zero: 208022, end: 207_917, caption: 'Predicted fuel cell depletion', hot: new List([ new Timer( start: 206_941, end: 206_945 ) ]) ),
 new Timer( start: 207917, zero: 208157, end: 209_031, caption: 'Predicted fuel cell depletion', hot: new List([ new Timer( start: 207_917, end: 207_921 ), new Timer( start: 208_097, end: 209_030 ) ]) ),
 
 new Timer( start: 217_527, zero: 221_388, end: 221_422, caption: 'Free-return trajectory engine burn', hot: new List([ new Timer( start: 221_328, end: 221_419 ) ]) )

 
 */

struct Event: Codable {
    
    /// The name to display on the screen
    var description: String
    
    /// The first MET Offset TimeInterval where the event should be active
    var metBegin: TimeInterval
    
    /// The expected end of the event
    ///
    /// Many of the events do not actually finish, but instead count down toward the expected time before they are replaced
    var metEnd: TimeInterval
    
    func displayTime(at metTime: TimeInterval) -> TimeInterval {
        return metEnd - metTime
    }
}
