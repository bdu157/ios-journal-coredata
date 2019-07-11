//
//  EntriesTableViewController.swift
//  ios-journal
//
//  Created by Dongwoo Pae on 7/10/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    var entryController = EntryController()
    
    var entries: [Entry] {
        return self.entryController.loadFromPersistentStore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath)
        guard let customCell = cell as? EntryTableViewCell else {return UITableViewCell()}
            let entry = entries[indexPath.row]
            customCell.entry = entry
        return cell
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = self.entries[indexPath.row]
            self.entryController.deleteEntry(for: entry)
            self.tableView.reloadData()
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCreateNew" {
            guard let destVC = segue.destination as? EntryDetailViewController else {return}
                destVC.entryController = self.entryController
        } else if segue.identifier == "ShowDetail" {
            guard let destVC = segue.destination as? EntryDetailViewController,
                let selectedRow = tableView.indexPathForSelectedRow else {return}
                destVC.entryController = self.entryController
                destVC.entry = entries[selectedRow.row]
        }
    }

}
