//
//  TranscriptList.swift
//  Apollo13Realtime
//
//  Created by Mike Muszynski on 7/9/20.
//  Copyright © 2020 Mike Muszynski. All rights reserved.
//

import SwiftUI

struct TranscriptList: View {
    @EnvironmentObject var mediaController: MediaController
    var transcript: Transcript
    
    var body: some View {
        List {
            ForEach(transcript, id: \.message) { entry in
                TranscriptCell(entry: entry)
                    .listRowBackground(transcript.activeIDs(for: mediaController.missionElapsedTime).contains(entry.id) ? Color.secondary : nil)
            }
        }
    }
}

struct TranscriptList_Previews: PreviewProvider {
    static var previews: some View {
        TranscriptList(transcript: .airGroundLoop)
            .environmentObject(MediaController())
    }
}
