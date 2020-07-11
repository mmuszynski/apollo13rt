//
//  METView.swift
//  Apollo13Realtime
//
//  Created by Mike Muszynski on 7/10/20.
//  Copyright © 2020 Mike Muszynski. All rights reserved.
//

import SwiftUI

struct METView: View {
    @EnvironmentObject var controller: MediaController
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Mission Elapsed Time")
                .font(Font.custom("menlo", size: 16))
            Text(MediaController.timeFormatter.string(from: controller.playerTimeInMET) ?? "--")
                .font(Font.custom("menlo", size: 24))
        }
    }
}

struct METView_Previews: PreviewProvider {
    static var previews: some View {
        METView()
            .environmentObject(MediaController())
    }
}
