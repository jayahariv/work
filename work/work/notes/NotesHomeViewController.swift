//
/*
NotesHomeViewController.swift
Created on: 10/15/18

Abstract:
 self descriptive

*/

import Cocoa

final class NotesHomeViewController: NSViewController {
    
    // MARK: Properties
    ///PRIVATE
    @IBOutlet private weak var textView: NSTextView!
    private let coredataManager = CoreDataManager.shared
    private var note: Note?
    private struct C {
        static let TITLE = "Logs"
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        loadContent()
        
    }
    
    override func viewDidDisappear() {
        save()
    }
}

private extension NotesHomeViewController {
    func initializeUI() {
        title = C.TITLE
    }
    
    func loadContent() {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let dateFrom = calendar.startOfDay(for: Date())
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.predicate =  NSPredicate(format: "date > %@", dateFrom as NSDate)
        do {
            note = try coredataManager.viewContext.fetch(fetchRequest).first
        } catch {
            print(error)
        }
        textView.string = note?.content ?? ""
    }
    
    func save() {
        let content = textView.string
        guard !content.isEmpty else {
            return
        }
        if note == nil  {
            note = Note(context: coredataManager.viewContext)
            note?.date = Date()
        }
        
        note?.content = content
        coredataManager.saveContext()
    }
}
