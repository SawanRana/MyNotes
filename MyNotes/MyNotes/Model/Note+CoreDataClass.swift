//
//  Note+CoreDataClass.swift
//  MyNotes
//
//  Created by Sawan Rana on 23/06/24.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {
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
