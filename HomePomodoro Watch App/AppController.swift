//
//  AppController.swift
//  HomePomodoro Watch App
//
//  Created by Леонид Попов on 13/04/2026.
//

import Foundation

class AppController {
    private var model: AppModel
    init(model: AppModel) {
        self.model = model
    }
    
    func startTimer () {
        self.model.startSession()
    }
}
