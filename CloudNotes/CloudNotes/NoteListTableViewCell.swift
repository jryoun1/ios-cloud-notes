//
//  NoteListTableViewCell.swift
//  CloudNotes
//
//  Created by 김지혜 on 2021/02/15.
//

import UIKit

class NoteListTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var updatedAtLabel: UILabel!
    @IBOutlet private weak var previewLabel: UILabel!
    private var model: Note?
    
    func setModel(_ model: Note) {
        self.model = model
        updateUI()
    }
    
    private func updateUI() {
        guard let note = model else { return }
        titleLabel.text = note.title
        updatedAtLabel.text = "\(note.lastModified)"
        previewLabel.text = note.body
    }
}