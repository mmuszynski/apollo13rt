//
//  TransportSlider.swift
//  Apollo13Realtime
//
//  Created by Mike Muszynski on 7/12/20.
//  Copyright © 2020 Mike Muszynski. All rights reserved.
//

import SwiftUI

struct TransportSlider: View {
    @Binding var value: TimeInterval
    var range: ClosedRange<TimeInterval>
    
    var body: some View {
        Slider(value: $value, in: range) { (x) in
            print(x)
        }
    }
}

struct TransportSlider_Previews: PreviewProvider {
    @State static var value: TimeInterval = 5.0
    
    static var previews: some View {
        TransportSlider(value: $value, range: 0.0...20.0)
            .previewLayout(.sizeThatFits)
    }
}
