//
//  CloudNotes - ListViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreData

protocol MemoSelectionDelegate: class {
    func memoSelected(_ memo: Memo)
}

final class ListViewController: UITableViewController {
    weak var delegate: MemoSelectionDelegate?
    private var managedContext: NSManagedObjectContext!
    private lazy var fetchedResultsController: NSFetchedResultsController<Memo> = {
      let fetchedRequest: NSFetchRequest<Memo> = Memo.fetchRequest()
        let dateSort = NSSortDescriptor(key: #keyPath(Memo.modifiedDate), ascending: false)
      fetchedRequest.sortDescriptors = [dateSort]
      
      let fetchedResultsController = NSFetchedResultsController(
        fetchRequest: fetchedRequest,
        managedObjectContext: managedContext,
        sectionNameKeyPath: nil,
        cacheName: nil)
      fetchedResultsController.delegate = self
      
      return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: "MemoTableViewCell")
        let appDelegate =
            UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
        fetchOldMemo()
        setUpDefaultMemo()
        setUpNavigationBar()
    }
    
    private func fetchOldMemo() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
    
    private func setUpDefaultMemo() {
        let index = UserDefaults.standard.integer(forKey: "lastMemoIndex")
        guard let oldMemo = fetchedResultsController.fetchedObjects,
              index < oldMemo.count else {
            return
        }
        delegate?.memoSelected(oldMemo[index])
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMemo))
    }
    
    @objc private func createMemo() {
        let newMemo = Memo(context: managedContext)
        delegate?.memoSelected(newMemo)
        
        if let detailViewController = delegate as? DetailViewController {
          splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }
}

// MARK: - extension TableView
extension ListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let memoCell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        memoCell.accessoryType = .disclosureIndicator
        let memo = fetchedResultsController.object(at: indexPath)
        memoCell.setUpMemoCell(memo)
        return memoCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedMemo = fetchedResultsController.object(at: indexPath)
        delegate?.memoSelected(selectedMemo)
        
        if let detailViewController = delegate as? DetailViewController {
          splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
        
        UserDefaults.standard.set(indexPath.row, forKey: "lastMemoIndex")
    }
}

extension ListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        // 둘다 nil
//        if let indexPath = indexPath,
//              let newIndexPath = newIndexPath else {
//            return
//        }
        let indexPath = IndexPath(row: 0, section: 0)
        let newIndexPath = IndexPath(row: 0, section: 0)
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            if let cell = tableView.cellForRow(at: indexPath) as? MemoTableViewCell {
                cell.accessoryType = .disclosureIndicator
                let memo = fetchedResultsController.object(at: indexPath)
                cell.setUpMemoCell(memo)
            }
        case .move:
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        @unknown default:
            print("Unexpected NSFetchedResultsChangeType")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
