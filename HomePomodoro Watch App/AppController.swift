//
//  AppController.swift
//  HomePomodoro Watch App
//
//  Created by Леонид Попов on 13/04/2026.
//

import Foundation
import Combine
import WatchKit
import EventKit

class AppController: ObservableObject {
    @Published var currentPomodoro: Pomodoro?
    @Published var timerDuaration: Float = 45
    private let eventStore = EKEventStore()
    
    func startSession () {
        self.currentPomodoro = Pomodoro(duarationMin: Int(self.timerDuaration)) {
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
