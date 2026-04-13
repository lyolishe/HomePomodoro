//
//  ContentView.swift
//  HomePomodoro Watch App
//
//  Created by Леонид Попов on 11/04/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var m = AppModel()
    
    var body: some View {
        if self.m.currentPomodoro !== nil {
            TimerView(pom: self.m.currentPomodoro!)
                .onTapGesture {
                    self.m.cancelCurrentPomodoro()
                }
        } else {
            VStack {
                Button("Start session of \(String(self.m.timerDuaration))") {
                    self.m.startSession()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
