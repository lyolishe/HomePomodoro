//
//  TimerVuew.swift
//  HomePomodoro Watch App
//
//  Created by Леонид Попов on 13/04/2026.
//

import SwiftUI

struct TimerView: View {
    @StateObject var pom: Pomodoro
    
    var body: some View {
        Circle()
            .strokeBorder(.red, lineWidth: 8)
            .padding()
            .overlay(
                Text(self.pom.timeUI)
                    .onReceive(self.pom.timer!) {_ in
                        self.pom.tick()
                    }
            )
    }
}
