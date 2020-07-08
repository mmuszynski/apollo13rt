//
//  TranscriptCell.swift
//  Apollo13Realtime
//
//  Created by Mike Muszynski on 7/2/20.
//  Copyright © 2020 Mike Muszynski. All rights reserved.
//

import SwiftUI
import os

var transcriptCellLogger = Logger(subsystem: "com.mmuszynski.apollo13rt", category: "TranscriptCell")

func annotatedText(from message: String) -> Text {
    guard let start = message.firstIndex(of: "{"),
          let end = message.firstIndex(of: "}") else {
        return Text(message)
    }
    
    let annotation = message[start..<end]
    let unchecked = String(message[end...])
    return Text(annotation).underline() + annotatedText(from: unchecked)
}

struct TranscriptCell: View {
    var entry: TranscriptEntry
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("3:30:04")
            VStack(alignment: .leading) {
                Text(entry.source)
                Text(entry.message)
                annotatedText(from: entry.message)
                ForEach(entry.annotations ?? [], id: \.hash) { string in
                    Text(string)
                }
            }
        }
    }
}

struct TranscriptCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TranscriptCell(entry: Transcript.airGroundLoop.first!)
                .previewLayout(.sizeThatFits)
            TranscriptCell(entry: Transcript.airGroundLoop.first(where: {$0.message.contains("{")})!)
                .previewLayout(.sizeThatFits)
        }
    }
}
