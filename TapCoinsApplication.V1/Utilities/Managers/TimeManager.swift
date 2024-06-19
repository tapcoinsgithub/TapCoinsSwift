//
//  TimeManager.swift
//  TapCoinsApplication.V1
//
//  Created by Eric Viera on 6/18/24.
//

import Foundation
class TimerManager: ObservableObject {
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    deinit {
        timer.upstream.connect().cancel()
    }
}
