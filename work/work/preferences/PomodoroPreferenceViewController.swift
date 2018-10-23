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
    
    override func viewWillAppear() {
        super.viewWillAppear()
        loadCategories()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        savePreferences()
    }
    
    @IBAction func onAddCategory(_ sender: Any) {
        showCategoryAddAlert()
    }
    
    @IBAction func onRemoveCategory(_ sender: Any) {
        guard let category = selectedCategory else {
            return
        }
        
        coredataManager.viewContext.delete(category)
        do {
            try coredataManager.viewContext.save()
        } catch {
            print(error)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.loadCategories()
        }
    }
}

private extension PomodoroPreferenceViewController {
    
    func fillDefaultValues(_ preference: Preference) {
        dailyTargetTextField.stringValue = "\(preference.dailyTarget)"
        workDurationTextField.stringValue = "\(preference.pomodoroDuration)"
        shortIntervalTextField.stringValue = "\(preference.shortIntervalDuration)"
        longIntervalTextField.stringValue = "\(preference.longIntervalDuration)"
        longIntervalAfterTextField.stringValue = "\(preference.longIntervalAfter)"
    }
    
    func savePreferences() {
        guard let preference = selectedCategory?.preference else{
            return
        }
        let dailyTarget = dailyTargetTextField.stringValue
        if let dailyTargetInt = Int16(dailyTarget), dailyTargetInt != preference.dailyTarget {
            preference.dailyTarget = dailyTargetInt
        }
        
        let workDuration = workDurationTextField.stringValue
        if let workDurationInt = Int16(workDuration), workDurationInt != preference.pomodoroDuration {
            preference.pomodoroDuration = workDurationInt
        }
        
        let shortInterval = shortIntervalTextField.stringValue
        if let shortIntervalInt = Int16(shortInterval), shortIntervalInt != preference.shortIntervalDuration {
            preference.shortIntervalDuration = shortIntervalInt
        }
        
        let longBreakDuration = longIntervalTextField.stringValue
        if let longBreakDurationInt = Int16(longBreakDuration), longBreakDurationInt != preference.longIntervalDuration {
            preference.longIntervalDuration = longBreakDurationInt
        }
        
        let longIntervalAfter = longIntervalAfterTextField.stringValue
        if let longIntervalAfterInt = Int16(longIntervalAfter), longIntervalAfterInt != preference.longIntervalAfter {
            preference.longIntervalAfter = longIntervalAfterInt
        }
        
        coredataManager.saveContext()
    }
    
    func loadCategories() {
        let fetchRequest: NSFetchRequest<TaskCategory> = TaskCategory.fetchRequest()
        do {
            categories = try coredataManager.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        selectedCategory = categories.first
        if let preference = selectedCategory?.preference {
            fillDefaultValues(preference)
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
                taskCategory.preference = Preference(context: self.coredataManager.viewContext)
                self.coredataManager.saveContext()
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {
                        return
                    }
                    
                    self.loadCategories()
                }
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
        selectedCategory = item as? TaskCategory
        if let preference = selectedCategory?.preference {
            fillDefaultValues(preference)
        }
        return true
    }
}
