//
//  EntryDetailViewController.swift
//  ios-journal
//
//  Created by Dongwoo Pae on 7/10/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        self.updateViews()
        self.titleTextField.addTarget(self, action: #selector(toggleSaveButton), for: .editingChanged)
    }
    
 
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let titleInput = titleTextField.text,
            let bodyTextInput = textView.text,
            let entryController = entryController else {return}
        
        if let entry = entry {
                entryController.updateEntry(title: titleInput, bodyText: bodyTextInput, for: entry)
        } else {
                entryController.createEntry(title: titleInput, bodyText: bodyTextInput)
            }
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        guard isViewLoaded else {return}
        
        if let entry = entry {
            self.titleTextField.text = entry.title
            self.textView.text = entry.bodyText
            self.title = entry.title
        } else {
            self.title = "Create Entry"
        }
    }
    
    @objc private func toggleSaveButton() {
            if !self.titleTextField.text!.isEmpty {
                self.saveButton.isEnabled = true
            } else {
                self.saveButton.isEnabled = false
                }
            }
}
