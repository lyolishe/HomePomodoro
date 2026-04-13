//
//  Model.swift
//  HomePomodoro Watch App
//
//  Created by Леонид Попов on 11/04/2026.
//

import Foundation
import Combine
import WatchKit
import EventKit

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


class AppModel: ObservableObject {
    @Published var currentPomodoro: Pomodoro?
    @Published var timerDuaration: Int = 45
    private let eventStore = EKEventStore()
    
    func startSession () {
        self.currentPomodoro = Pomodoro(duarationMin: self.timerDuaration) {
            self.currentPomodoro = nil;
            WKInterfaceDevice.current().play(.notification)
        }
        self.currentPomodoro?.startSession()
    }
    
    func cancelCurrentPomodoro () {
        if let currentPomodoro = self.currentPomodoro {
            currentPomodoro.endSession();
            self.currentPomodoro = nil;
        }
    }
    
    func setToCalendar() {
        if let currentPomodoro = self.currentPomodoro {
            eventStore.requestAccess(to: .event ) { (granted, error) in
                if granted {
                    let newEvent = EKEvent(eventStore: self.eventStore)
                    newEvent.title = "Помидорка"
                    newEvent.startDate = currentPomodoro.timeStarted;
                    newEvent.endDate = Date()
                    newEvent.calendar = self.eventStore.calendar(withIdentifier: "HomePomodoro")
                    
                    do {
                        // Saving calendar events on watchOS is not avaliable.
                        // TODO: write mobile app and process calendar events there.
                        // try self.eventStore.save(newEvent, commit: true)
                    }
                }
            }
        } else {return}
    }
}

