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

func annotatedText(for entry: TranscriptEntry) -> Text {
    var text = Text("")
    
    for part in entry.messageInParts {
        switch part {
        case .plain(let message):
            text = text + Text(message)
        case .annotated(let message, _, let index):
            text = text + Text(message).underline()
            text = text + Text("\(index + 1)")
                .font(.caption)
                .baselineOffset(6.0)
        }
    }
    
    return text
}

struct TranscriptCell: View {
    var entry: TranscriptEntry
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("\(entry.start!)")
            VStack(alignment: .leading) {
                Text(entry.source)
                annotatedText(for: entry)
                ForEach(entry.tokens ?? [], id: \.hash) { string in
                    Text("\((entry.tokens?.firstIndex(of: string) ?? 0) + 1): ")
                        .font(.caption)
                        .italic() +
                    Text(string)
                        .font(.caption)
                        .italic()
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
