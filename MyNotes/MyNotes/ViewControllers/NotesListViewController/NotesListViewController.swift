//
//  NotesListViewController.swift
//  MyNotes
//
//  Created by Sawan Rana on 23/06/24.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController {

    @IBOutlet weak var notesCountLbl: UILabel!
    @IBOutlet weak var createNoteBtn: UIButton!
    
    @IBOutlet weak var deleteAllButton: UIButton!
    @IBAction func deleteAllAction(_ sender: Any) {
//        totalNotes.forEach {
//            deleteNote(for: $0.id)
//        }
        
        deleteAllNotes()
    }
    
    @IBOutlet weak var notesTblView: UITableView!
    
    private let searchController = UISearchController()
    
    private var fetchedResultController: NSFetchedResultsController<Note>!
    
//    private var totalNotes: [Note] = [] {
//        didSet {
//            let totalNotesCount = totalNotes.count
//            let notesString = totalNotesCount > 1 ? "Notes" : "Note"
//            notesCountLbl.text = "You have \(totalNotesCount) \(notesString)"
//            filteredNotes = totalNotes
//            deleteAllButton.isHidden = filteredNotes.count == 0
//        }
//    }
//    private var filteredNotes: [Note] = [Note]()
    
    @IBAction func createNoteAction(_ sender: UIButton) {
        createNotesEditViewController(createNewNote())
    }
    
    private func createNewNote() -> Note {
        let note = NotesCDManager.shared.createNewNote()
//        totalNotes.insert(note, at: 0)
//        notesTblView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
        return note
    }
    
    private func deleteAllNotes() {
//        if fetchedResultController.fetchedObjects?.count ?? 0 > 100 {
//            NotesCDManager.shared.deleteAll()
//            
//            try? fetchedResultController.performFetch()
//            
//            notesTblView.reloadData()
//        } else {
        fetchedResultController.fetchedObjects?.forEach{ note in
            NotesCDManager.shared.deleteNote(note)
        }
//        }
        
        setTotalNoteCountLbl()
    }
    
    private func setTotalNoteCountLbl() {
        guard let totalNotesCount = fetchedResultController.sections?[0].numberOfObjects else {
            notesCountLbl.text = ""
            return
        }
        let notesString = totalNotesCount > 1 ? "Notes" : "Note"
        notesCountLbl.text = "You have \(totalNotesCount) \(notesString)"
        deleteAllButton.isHidden = totalNotesCount < 1
    }
    
    private func createNotesEditViewController(_ note: Note) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let notesEditVC = storyboard.instantiateViewController(withIdentifier: NotesEditViewController.identifier) as? NotesEditViewController else {
            print("Can not create new note")
            return
        }
        
//        notesEditVC.delegate = self
        notesEditVC.note = note
        
        self.navigationController?.pushViewController(notesEditVC, animated: true)
    }
    
//    private func indexPathForNote(for id: UUID, in notes: [Note]) -> IndexPath {
//        let noteIndex = notes.firstIndex(where: { $0.id == id })
//        let indexPath = IndexPath(row: Int(noteIndex ?? 0), section: 0)
//        return indexPath
//    }
    
    private func deleteNoteFromTotalNotes(_ note: Note) {
//        deleteNote(for: note.id)
        NotesCDManager.shared.deleteNote(note)
    }
    
    private func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.clipsToBounds = true
        searchController.delegate = self
        searchController.searchBar.delegate = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
//        fetchNotesFromCDStorage()
        setupNoteFetchedResultController()
        setTotalNoteCountLbl()
    }
    
    private func setupNoteFetchedResultController(filter: String? = nil) {
        fetchedResultController = NotesCDManager.shared.createNoteFetchedResultController(filter: filter)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print("Error in performing fetch: \(error.localizedDescription)")
        }
    }
    
//    private func resetNoteTblViewForSearch() {
//        filteredNotes = []
//        notesTblView.reloadData()
//    }
    
//    private func fetchNotesFromCDStorage() {
//        totalNotes = NotesCDManager.shared.fetchNotes()
//    }
    
//    private func searchNotesFromCDStorage(text: String? = nil) {
//        filteredNotes = NotesCDManager.shared.fetchNotes(filter: text)
//    }

}

extension NotesListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredNotes.count
        guard let notesCount = fetchedResultController.sections?[section].numberOfObjects else {
            return 0
        }
        return notesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesEditTableViewCell.identifier, for: indexPath) as? NotesEditTableViewCell else {
            return UITableViewCell()
        }
        let note = fetchedResultController.object(at: indexPath)
        cell.setup(with: note)
        return cell
    }
    
}

extension NotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let note = filteredNotes[indexPath.row]
        let note = fetchedResultController.object(at: indexPath)
        createNotesEditViewController(note)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            print("Notes should be removed from total notes")
            let note = fetchedResultController.object(at: indexPath)
            deleteNoteFromTotalNotes(note)
        default:
            break
        }
    }
}

//extension NotesListViewController: NotesEditDelegate {
//    func deleteNote(for id: UUID) {
//        let indexPathForNote = indexPathForNote(for: id, in: totalNotes)
//        totalNotes.remove(at: indexPathForNote.row)
//        notesTblView.deleteRows(at: [indexPathForNote], with: .automatic)
//    }
//    
//    func refreshNotes() {
//        totalNotes = totalNotes.sorted(by: { $0.lastUpdated > $1.lastUpdated })
//        notesTblView.reloadData()
//    }
//}

extension NotesListViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            resetNoteTblViewForSearch()
//        } else {
//            search(for: searchText)
//        }
        search(for: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        resetNoteTblViewForSearch()
        createNoteBtn.isHidden = true
        search(for: searchBar.text ?? "",  searchForEmptyText: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        filteredNotes = totalNotes
//        notesTblView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        createNoteBtn.isHidden = false
        search(for: "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let queryText = searchBar.text
        
        search(for: queryText ?? "")
    }
    
    private func search(for queryText: String, searchForEmptyText: Bool = false) {
//        if queryText.count >= 1 {
//            filteredNotes = totalNotes.filter { $0.text.lowercased().contains(queryText.lowercased()) }
//        } else {
//            filteredNotes = totalNotes
//        }
//        searchNotesFromCDStorage(text: queryText)
//        notesTblView.reloadData()
        
        if queryText.isEmpty && !searchForEmptyText {
            setupNoteFetchedResultController()
        } else {
            setupNoteFetchedResultController(filter: queryText)
        }
        setTotalNoteCountLbl()
        notesTblView.reloadData()
        
    }
}

extension NotesListViewController: NSFetchedResultsControllerDelegate {
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
//        print("Will change content")
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
//        print("Did change content")
//    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                notesTblView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                notesTblView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                notesTblView.moveRow(at: indexPath, to: newIndexPath)
            }
        case .update:
            if let indexPath = indexPath {
                notesTblView.reloadRows(at: [indexPath], with: .automatic)
            }
        default:
            notesTblView.reloadData()
        }
        
        setTotalNoteCountLbl()
    }
}
