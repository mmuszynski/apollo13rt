//
//  TranscriptList.swift
//  Apollo13Realtime
//
//  Created by Mike Muszynski on 7/9/20.
//  Copyright © 2020 Mike Muszynski. All rights reserved.
//

import SwiftUI

struct TranscriptList: View {
    var transcript: Transcript
    
    var body: some View {
        List(transcript, id: \.id) { entry in
            TranscriptCell(entry: entry)
        }
    }
}

struct TranscriptList_Previews: PreviewProvider {
    static var previews: some View {
        TranscriptList(transcript: .airGroundLoop)
    }
}
