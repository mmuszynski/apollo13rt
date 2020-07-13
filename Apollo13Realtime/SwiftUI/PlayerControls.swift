//
//  PlayerControls.swift
//  Apollo13Realtime
//
//  Created by Mike Muszynski on 7/10/20.
//  Copyright © 2020 Mike Muszynski. All rights reserved.
//

import SwiftUI

struct PlayerControls: View {
    @EnvironmentObject var controller: MediaController
    @State var scrubTime: TimeInterval = 0
    @State var isUpdatingSlider: Bool = false {
        didSet {
            if !isUpdatingSlider {
                controller.missionElapsedTime = self.scrubTime
            } else {
                scrubTime = controller.missionElapsedTime
            }
        }
    }
    @GestureState var isDetectingTap: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Group {
                    let secs = [60, 30, 10]
                    ForEach(secs, id: \.self) { seconds in
                        Button(action: {
                            self.controller.zeroToleranceSeekBack(TimeInterval(seconds))
                        }, label: {
                            Image(systemName: "gobackward.\(seconds)")
                        })
                    }
                    
                    Button(action: controller.togglePlayer, label: {
                        switch controller.audioPlayerStatus {
                        case .playing:
                            Image(systemName: "pause.fill")
                        default:
                            Image(systemName: "play.fill")
                        }
                    })
                    .padding([.leading, .trailing], /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    
                    ForEach(secs.reversed(), id: \.self) { seconds in
                        Button(action: {
                            self.controller.zeroToleranceSeekAhead(TimeInterval(seconds))
                        }, label: {
                            Image(systemName: "goforward.\(seconds)")
                        })
                    }
                }
                .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .imageScale(.large)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
            
            Slider(value: $controller.missionElapsedTime, in: controller.validMETRange)
            Slider(value: isUpdatingSlider ? $scrubTime : $controller.missionElapsedTime, in: controller.validMETRange) { (isChanging) in
                isUpdatingSlider = isChanging
            }
            TransportSlider(value: $controller.missionElapsedTime, range: controller.validMETRange)
        }
    }
}

struct PlayerControls_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControls()
            .environmentObject(MediaController())
            .previewLayout(.sizeThatFits)
    }
}
