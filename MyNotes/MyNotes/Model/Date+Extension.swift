//
//  Date+Extension.swift
//  MyNotes
//
//  Created by Sawan Rana on 23/06/24.
//

import Foundation

extension Date {
    
    func dateFormat() -> String {
        let formatter = DateFormatter()
        if (Calendar.current.isDateInToday(self)) {
            formatter.dateFormat = "h:mm a"
        } else {
            formatter.dateFormat = "dd/MM/yy"
        }
        return formatter.string(from: self)
    }
}
