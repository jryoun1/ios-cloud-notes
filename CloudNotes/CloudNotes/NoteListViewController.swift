//
//  NoteListViewController.swift
//  CloudNotes
//
//  Created by 김지혜 on 2021/02/15.
//

import UIKit

class NoteListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNotes()
    }
    
    private func getNotes() {
//        let urlPath = Bundle.main.url(forResource: "sample", withExtension: "json")
//        let bundle = Bundle(for: NoteData.self)
//        let url = bundle.url(forResource: "sample", withExtension: "json")
        guard let fileURL = Bundle.main.url(forResource: "sample", withExtension: "json") else {
            print("couldn't find the file")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let notes = try decoder.decode([Note].self, from: jsonData)
            NoteData.shared.notes = notes
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? NoteDetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            if NoteData.shared.notes.count > indexPath.row {
                // index out of bound 위험?
                detailViewController.setModel(NoteData.shared.notes[indexPath.row])
            }
        }
    }
}

extension NoteListViewController: UITableViewDelegate {
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NoteData.shared.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteListTableViewCell", for: indexPath) as? NoteListTableViewCell else { return .init() }
        cell.setModel(NoteData.shared.notes[indexPath.row])
        
        return cell
    }
}
