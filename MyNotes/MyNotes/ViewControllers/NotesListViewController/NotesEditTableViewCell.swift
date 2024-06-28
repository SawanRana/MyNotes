//
//  NotesEditTableViewCell.swift
//  MyNotes
//
//  Created by Sawan Rana on 23/06/24.
//

import UIKit

class NotesEditTableViewCell: UITableViewCell {
    static let identifier = "NotesEditTableViewCell"

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(with note: Note) {
        self.titleLbl.text = note.title
        self.descLbl.text = note.desc
    }

}
