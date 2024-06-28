//
//  NotesEditViewController.swift
//  MyNotes
//
//  Created by Sawan Rana on 23/06/24.
//

import UIKit

//Implementing NSFetchedResultController
//protocol NotesEditDelegate: AnyObject {
//    func refreshNotes()
//    func deleteNote(for id: UUID)
//}

class NotesEditViewController: UIViewController {
    var note: Note!
//    weak var delegate: NotesEditDelegate? = nil
    @IBOutlet weak var textView: UITextView!
    
    static let identifier = "NotesEditViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.text = note.text
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func deleteNote() {
        print("Deleting the note for id: \(String(describing: note.id))")
//        delegate?.deleteNote(for: note.id)
        NotesCDManager.shared.deleteNote(note)
    }
    
    private func refreshNotes() {
        print("Refreshing the note")
        NotesCDManager.shared.save()
//        delegate?.refreshNotes()
    }
}

extension NotesEditViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        guard !textView.text.isEmpty else {
            deleteNote()
            return
        }
        //Updating the note text
        note.text = textView.text
        note.lastUpdated = Date()
        refreshNotes()
    }
}
