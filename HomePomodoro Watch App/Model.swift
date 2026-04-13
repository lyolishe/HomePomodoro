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
    var onEnd: () -> Void
    
    @Published var timeLeft: Int
    
    init(duarationMin: Float, onEnd: @escaping () -> Void) {
        self.timeLeft = Int(duarationMin*60);
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


class AppModel: ObservableObject {
    @Published var currentPomodoro: Pomodoro?
    @Published var timerDuaration: Float = 0.2
        
    func startSession () {
        self.currentPomodoro = Pomodoro(duarationMin: self.timerDuaration) {
            self.currentPomodoro = nil;
        }
        self.currentPomodoro?.startSession()
    }
    
    func cancelCurrentPomodoro () {
        if let currentPomodoro = self.currentPomodoro {
            currentPomodoro.endSession();
            self.currentPomodoro = nil;
        }
    }
}

