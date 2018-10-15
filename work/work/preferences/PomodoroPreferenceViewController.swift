//
/*
PomodoroPreferenceViewController.swift
Created on: 10/14/18

Abstract:
 Pomodoro settings view controller

*/

import Cocoa

final class PomodoroPreferenceViewController: NSViewController {
    @IBOutlet private weak var dailyTargetTextField: NSTextField!
    @IBOutlet private weak var workDurationTextField: NSTextField!
    @IBOutlet private weak var shortIntervalTextField: NSTextField!
    @IBOutlet private weak var longIntervalTextField: NSTextField!
    @IBOutlet private weak var longIntervalAfterTextField: NSTextField!

    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillDefaultValues()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        savePreferences()
    }
    
}

private extension PomodoroPreferenceViewController {
    
    func fillDefaultValues() {
        dailyTargetTextField.stringValue = "\(UserPreference.shared.dailyWorkTarget)"
        workDurationTextField.stringValue = "\(UserPreference.shared.workDuration)"
        shortIntervalTextField.stringValue = "\(UserPreference.shared.shortBreakDuration)"
        longIntervalTextField.stringValue = "\(UserPreference.shared.longBreakDuration)"
        longIntervalAfterTextField.stringValue = "\(UserPreference.shared.longBreakAfter)"
    }
    
    func savePreferences() {
        let dailyTarget = dailyTargetTextField.stringValue
        if let dailyTargetInt = Int(dailyTarget), dailyTargetInt != UserPreference.shared.dailyWorkTarget {
            UserPreference.shared.saveDailyWorkTarget(dailyTargetInt)
        }
        
        let workDuration = workDurationTextField.stringValue
        if let workDurationInt = Int(workDuration), workDurationInt != UserPreference.shared.workDuration {
            UserPreference.shared.saveWorkDuration(workDurationInt)
        }
        
        let shortInterval = shortIntervalTextField.stringValue
        if let shortIntervalInt = Int(shortInterval), shortIntervalInt != UserPreference.shared.shortBreakDuration {
            UserPreference.shared.saveShortBreakDuration(shortIntervalInt)
        }
        
        let longBreakDuration = longIntervalTextField.stringValue
        if let longBreakDurationInt = Int(longBreakDuration), longBreakDurationInt != UserPreference.shared.longBreakDuration {
            UserPreference.shared.saveLongBreakDuration(longBreakDurationInt)
        }
        
        let longIntervalAfter = longIntervalAfterTextField.stringValue
        if let longIntervalAfterInt = Int(longIntervalAfter), longIntervalAfterInt != UserPreference.shared.longBreakAfter {
            UserPreference.shared.saveLongBreakAfter(longIntervalAfterInt)
        }
    }
}
