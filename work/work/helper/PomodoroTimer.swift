//
/*
PomodoroTimer.swift
Created on: 10/6/18

Abstract:
 This class will be the timer

*/

import Foundation
import Repeat
import CoreData

final class PomodoroTimer {
    /// PUBLIC
    static var shared: PomodoroTimer {
        return instance
    }
    var state: Repeater.State {
        return timer?.state ?? .finished
    }
    var time: String {
        return String(format: "%02d:%02d",
                      remainingSeconds / TimeConstants.MINUTE_IN_SECONDS,
                      remainingSeconds % TimeConstants.MINUTE_IN_SECONDS)
    }
    var minute: String {
        return String(format: "%02d", remainingSeconds / TimeConstants.MINUTE_IN_SECONDS)
    }
    var todaysFinishedTaskCount: Int {
        return getTodaysFinishedTasks().count
    }
    
    struct Constants {
        struct NotificationName {
            static let TOGGLE = "NOTIFICATION_TOGGLE_NAME"
            static let FINISH = "NOTIFICATION_FINISH_NAME"
        }
    }
    /// PRIVATE
    private static let instance = PomodoroTimer()
    private var timer: Repeater?
    private var remainingSeconds: Int = 0
    private var isWorking: Bool = false
    private let coredataManager = CoreDataManager.shared
    
    private var resignDate: Date?
    private var resignRemainingSeconds: Int = 0
    
    /**
     Call this method once for setting up the timer from AppDelegate
     
     */
    func setupTimer() {
        guard timer == nil else {
            return
        }
        initializeAppNotifications()
        isWorking = true
        remainingSeconds = UserPreference.shared.workDuration * TimeConstants.MINUTE_IN_SECONDS
        timer = Repeater.every(.seconds(1)) { [weak self] (_) in
            guard let self = self else {
                return
            }
            
            guard self.remainingSeconds > 0 else {
                self.finishTimer()
                return
            }
            self.remainingSeconds -= 1
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
        NotificationCenter.default.post(name: Notification.Name(PomodoroTimer.Constants.NotificationName.TOGGLE),
                                        object: nil)
    }
    
    func skip() {
        if let state = timer?.state, state == .executing {
            toggle()
        }
        
        if isWorking {
            let eligibleForLongBreak =
                todaysFinishedTaskCount != 0 &&
                    todaysFinishedTaskCount % UserPreference.shared.longBreakAfter == 0
            let nextIntervalInMinutes =
                eligibleForLongBreak
                    ? UserPreference.shared.longBreakDuration
                    : UserPreference.shared.shortBreakDuration
            remainingSeconds = nextIntervalInMinutes * TimeConstants.MINUTE_IN_SECONDS
        } else {
            remainingSeconds = UserPreference.shared.workDuration * TimeConstants.MINUTE_IN_SECONDS
        }
        isWorking.toggle()
    }
}

private extension PomodoroTimer {
    func finishTimer() {
        if isWorking {
            saveInterval()
            if todaysFinishedTaskCount == UserPreference.shared.dailyWorkTarget {
                Notify.shared.dailyTargetAchieved()
            } else {
                Notify.shared.takeBreak()
            }
        } else {
            Notify.shared.timeToWork()
        }
        timer?.pause()
        skip()
    }
    
    func saveInterval() {
        let task = Task(context: coredataManager.viewContext)
        task.date = Date()
        coredataManager.saveContext()
    }
    
    func getTodaysFinishedTasks() -> [Task] {
        var tasks = [Task]()
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let dateFrom = calendar.startOfDay(for: Date())

        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate =  NSPredicate(format: "date > %@", dateFrom as NSDate)
        do {
            tasks = try coredataManager.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        return tasks
    }
}

extension PomodoroTimer {
    func initializeAppNotifications() {
        NSWorkspace
            .shared
            .notificationCenter
            .addObserver(self,
                         selector: #selector(onSleepNote(note:)),
                         name: NSWorkspace.screensDidSleepNotification,
                         object: nil)
        NSWorkspace
            .shared
            .notificationCenter
            .addObserver(self,
                         selector: #selector(onWakeNote(note:)),
                         name: NSWorkspace.screensDidWakeNotification,
                         object: nil)
    }
    
    @objc func onWakeNote(note: NSNotification) {
        correctResignTime()
    }
    
    @objc func onSleepNote(note: NSNotification) {
        resignDate = Date()
        resignRemainingSeconds = remainingSeconds
    }
    
    func correctResignTime() {
        if resignDate != nil && timer?.state ?? .finished == .executing {
            let timeSinceResign = NSDate().timeIntervalSince(resignDate!)
            let stopwatch = Int(timeSinceResign)
            remainingSeconds = resignRemainingSeconds - stopwatch
            print("resignRemainingSeconds: \(resignRemainingSeconds); stopwatch; \(stopwatch); remainingSeconds: \(remainingSeconds)")
            resignDate = nil
        } else if !isWorking {
            skip()
            NotificationCenter.default.post(name: Notification.Name(PomodoroTimer.Constants.NotificationName.TOGGLE),
                                            object: nil)
        }
    }
}
