//
//  CountdownTimer.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 9/3/22.
//

import Foundation

extension SpeedTracker {
    final class ViewModel: ObservableObject {
        @Published var isActive = false
        @Published var seconds: Int = 10
        
        private var initialTime = 0
        private var endDate = Date()
        
        func start(seconds: Int) {
            self.initialTime = seconds
            self.endDate = Date()
            self.isActive = true
            self.endDate = Calendar.current.date(byAdding: .second, value: seconds, to: endDate)!
        }
        
        // Stop the timer
        func stop() {
            self.isActive = false
        }
        
        // Show updates of the timer
        func updateCountdown(){
            guard isActive else { return }
            
            // Gets the current date and makes the time difference calculation
            let now = Date()
            let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
            
            // Checks that the countdown is not <= 0
            if diff <= 0 {
                self.isActive = false
                return
            }
            
            // Turns the time difference calculation into sensible data and formats it
            let date = Date(timeIntervalSince1970: diff)

            // Updates the time string with the formatted time
            self.seconds = Calendar.current.component(.second, from: date)
        }
        
        func getSeconds() -> Int {
            return seconds
        }
    }
}
