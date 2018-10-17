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
    private var categories: [String] = ["Other"]

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

extension PomodoroPreferenceViewController: NSOutlineViewDataSource, NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return categories.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return categories[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        let v =
            outlineView
                .makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DataCell"),
                          owner: self) as! NSTableCellView
        if let tf = v.textField {
            tf.stringValue = item as! String
        }
        return v
    }

}
