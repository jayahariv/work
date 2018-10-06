//
/*
PomodoroTimer.swift
Created on: 10/6/18

Abstract:
 This class will be the timer

*/

import Foundation
import Repeat

final class PomodoroTimer {
    private static let instance = PomodoroTimer()
    static var shared: PomodoroTimer {
        return instance
    }
    private var timer: Repeater?
    private var remainingSeconds: Int = 0
    private struct C {
        static let LONG_INTERVAL_SEC = 1500
        static let SHORT_BREAK_SEC = 300
        static let LONG_BREAK_SEC = 900
    }
    
    var state: Repeater.State {
        return timer?.state ?? .finished
    }
    
    func setupTimer() {
        guard timer == nil else {
            return
        }
        remainingSeconds = C.LONG_INTERVAL_SEC
        timer = Repeater.every(.seconds(1)) { [weak self] (_) in
            guard let self = self else {
                return
            }
            
            guard self.remainingSeconds > 0 else {
                self.reset()
                return
            }
            self.remainingSeconds -= 1
            
            print(self.remainingSeconds)
        }
        timer?.pause()
    }
    
    func toggle() {
        if timer == nil {
            setupTimer()
        }
        if timer?.state == .executing {
            timer?.pause()
        } else if timer?.state == .paused {
            timer?.start()
        }
    }
    
    func displayTime() -> String {
        let minutesPart = remainingSeconds / TimeConstants.MINUTE_IN_SECONDS
        let secondsPart = remainingSeconds % TimeConstants.MINUTE_IN_SECONDS
        return String(format: "%02d:%02d", minutesPart, secondsPart)
    }
    
    func reset() {
        timer = nil
    }
}
