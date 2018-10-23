//
/*
CounterViewController.swift
Created on: 10/4/18

Abstract:
 This will be the popover view controller

*/

import Cocoa
import Repeat

final class CounterViewController: NSViewController {
    // MARK: Properties
    /// PRIVATE
    @IBOutlet private weak var counterTextfield: NSTextField?
    @IBOutlet private weak var countersubheading: NSTextField?
    @IBOutlet private weak var counterContainer: CounterContainerView!
    @IBOutlet private weak var categoriesPopButton: NSPopUpButton!
    private let pomodoroTimer = PomodoroTimer.shared
    private var uiUpdater: Repeater?
    private let coredataManager = CoreDataManager.shared
    private var categories = [TaskCategory]()
    private var selectedCatgory: TaskCategory?
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        updateCounter()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        refreshUI()
    }
    
    // MARK: Button Actions
    @IBAction func onQuit(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
    
    @IBAction func onSelectMenuItem(_ sender: Any) {
        if let menuItem = categoriesPopButton.selectedItem {
            selectedCatgory = TaskCategoryManager.getCategory(menuItem.title)
            refreshUI()
        }
    }
}



extension CounterViewController {
    static func freshController() -> CounterViewController {
        guard let viewcontroller =
            NSStoryboard(name: "Main", bundle: nil)
                .instantiateController(withIdentifier: "CounterViewController")
                    as? CounterViewController
        else {
            fatalError("Why cant i find CounterViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

private extension CounterViewController {
    func initializeView() {
        counterContainer.delegate = self
        let fetchRequest: NSFetchRequest<TaskCategory> = TaskCategory.fetchRequest()
        do {
            categories = try coredataManager.viewContext.fetch(fetchRequest)
            selectedCatgory = categories.first
        } catch {
            print(error)
        }
        updateCategoryPushButton()
    }
    
    func updateCounter() {
        uiUpdater = Repeater.every(.seconds(1)) { [weak self] (_) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.counterTextfield?.stringValue = self.pomodoroTimer.time
            }
        }
        uiUpdater?.start()
    }
    
    func updateCategoryPushButton() {
        categoriesPopButton.removeAllItems()
        for category in categories {
            if let name = category.name {
                categoriesPopButton.addItem(withTitle: name)
            }
        }
    }
    
    func refreshUI() {
        if  let dailyTarget = selectedCatgory?.preference?.dailyTarget {
            countersubheading?.stringValue = "\(pomodoroTimer.todaysFinishedTaskCount)/\(dailyTarget)"
        }
    }
}

extension CounterViewController: CounterContainerViewProtocol {
    func onMouseDown() {
        pomodoroTimer.toggle()
    }
}
