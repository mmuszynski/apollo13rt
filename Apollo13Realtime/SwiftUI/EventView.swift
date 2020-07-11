//
//  EventView.swift
//  Apollo13Realtime
//
//  Created by Mike Muszynski on 7/10/20.
//  Copyright © 2020 Mike Muszynski. All rights reserved.
//

import SwiftUI

struct EventView: View {
    @EnvironmentObject var controller: MediaController
    
    var body: some View {
        VStack(alignment: .trailing) {
            if let event = controller.currentEvent {
                Text(event.description)
                    .font(Font.custom("menlo", size: 16))
                
                let interval = event.displayTime(at: controller.missionElapsedTime)
                
                Text(MediaController.timeFormatter.string(from: interval) ?? "--")
                    .font(Font.custom("menlo", size: 24))
            } else {
                EmptyView()
            }
        }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView()
            .environmentObject(MediaController())
    }
}
