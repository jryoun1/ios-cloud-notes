//
//  NoteData.swift
//  CloudNotes
//
//  Created by 김지혜 on 2021/02/15.
//

import Foundation

class NoteData {
    static let shared = NoteData()
    var notes: [Note] = []
    
    private init() {}
}
