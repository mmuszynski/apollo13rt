//
//  TranscriptViewer.swift
//  Apollo13Realtime
//
//  Created by Mike Muszynski on 7/10/20.
//  Copyright © 2020 Mike Muszynski. All rights reserved.
//

import SwiftUI

struct TranscriptViewer: View {
    var body: some View {
        HStack(spacing: 0) {
            TranscriptList(transcript: .airGroundLoop)
            Divider()
            TranscriptList(transcript: .flightDirectorLoop)
        }
    }
}

struct TranscriptViewer_Previews: PreviewProvider {
    static var previews: some View {
        TranscriptViewer()
    }
}