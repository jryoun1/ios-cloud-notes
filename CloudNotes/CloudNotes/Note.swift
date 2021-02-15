//
//  Note.swift
//  CloudNotes
//
//  Created by 김지혜 on 2021/02/15.
//

import Foundation

struct Note: Decodable {
    let title: String
    let body: String
    let lastModified: Int
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
