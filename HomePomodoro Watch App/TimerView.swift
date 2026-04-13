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
        ZStack {
            Circle()
                .stroke(.yellow, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .padding()
                .overlay(
                    Text(self.pom.timeUI)
                        .onReceive(self.pom.timer!) {_ in
                            self.pom.tick()
                        }
                )
            Circle()
                .trim(from: 0, to: CGFloat(self.pom.timeLeft)/CGFloat(self.pom.duaration))
                .stroke(.purple, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: self.pom.timeLeft)
                .padding()
        }
    }
}
