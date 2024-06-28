//
//  Note.swift
//  MyNotes
//
//  Created by Sawan Rana on 23/06/24.
//

import Foundation

//This class is not needed more, core data model is generated
class NoteModel {
    var text: String = ""
    var id: UUID = UUID()
    var lastUpdated: Date = Date()
    
    //Retrieve first line from the text
    var title: String {
        text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).first ?? ""
    }
    
    //Retrieve second line from the text
    var desc: String {
        var totalLines = text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
        totalLines.removeFirst()
        let secondLine = totalLines.first ?? ""
        return "\(lastUpdated.dateFormat()) \(secondLine)"
    }
    
}
