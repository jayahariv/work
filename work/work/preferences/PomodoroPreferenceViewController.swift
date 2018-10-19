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
    @IBOutlet private weak var outlineView: NSOutlineView!
    private var categories = [TaskCategory]()
    private var selectedCategory: TaskCategory?
    private let coredataManager = CoreDataManager.shared

    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        fillDefaultValues()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        savePreferences()
    }
    
    @IBAction func onAddCategory(_ sender: Any) {
        showCategoryAddAlert()
    }
    
    @IBAction func onRemoveCategory(_ sender: Any) {
        // todo: implement
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
    
    func loadCategories() {
        let fetchRequest: NSFetchRequest<TaskCategory> = TaskCategory.fetchRequest()
        do {
            categories = try coredataManager.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        outlineView.reloadData()
    }
    
    func showCategoryAddAlert() {
        let delegate = NSApplication.shared.delegate as! AppDelegate
        guard let window = delegate.preferenceWindowController.window else {
            fatalError()
        }
        
        let alert = NSAlert()
        alert.messageText = "Add Custom Category"
        alert.alertStyle = .warning
        let categoryNameTextField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        categoryNameTextField.placeholderString = "Enter your category name"
        alert.accessoryView = categoryNameTextField
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.beginSheetModal(for: window, completionHandler: { [weak self] (modalResponse) -> Void in
            let categoryName = categoryNameTextField.stringValue
            guard let self = self, !categoryName.isEmpty else {
                return
            }
            
            if modalResponse == .alertFirstButtonReturn {
                let taskCategory = TaskCategory(context: self.coredataManager.viewContext)
                taskCategory.name = categoryName
                self.coredataManager.saveContext()
            }
        })
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
            let taskCategory = item as! TaskCategory
            tf.stringValue = taskCategory.name ?? "--"
        }
        return v
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        selectedCategory = item as! TaskCategory
        return true
    }
}
