//
//  Model.swift
//  HomePomodoro Watch App
//
//  Created by Леонид Попов on 11/04/2026.
//

import Foundation
import Combine

class Pomodoro: ObservableObject {
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    let timeStarted: Date = Date()
    var onEnd: () -> Void
    
    @Published var duaration: Int
    @Published var timeLeft: Int
    
    init(duarationMin: Int, onEnd: @escaping () -> Void) {
        self.duaration = duarationMin*60
        self.timeLeft = duarationMin*60;
        self.onEnd = onEnd;
    }
    
    func startSession() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func endSession() {
        if let timer = self.timer {
            timer.upstream.connect().cancel()
            self.onEnd()
        } else {return}
    }
    
    func tick() {
        if (self.timeLeft > 0) {
            self.timeLeft-=1
        } else {
            self.endSession()
        }
    }
    
    var timeUI: String {
        get {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            
            return formatter.string(from: TimeInterval(self.timeLeft)) ?? "0:00"
        }
    }
}

