//
//  EntryDetailViewController.swift
//  ios-journal
//
//  Created by Dongwoo Pae on 7/10/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController, UITextFieldDelegate {

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
        self.titleTextField.delegate = self
//        self.toggleSaveButton()
//        self.titleTextField.addTarget(self, action: #selector(toggleSaveButton), for: .editingChanged)
        if let _ = entry {
            self.saveButton.isEnabled = true
        }
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
    
//    @objc private func toggleSaveButton() {
//   self.saveButton.isEnabled = !self.titleTextField.text!.isEmpty
//                          or
//            if !self.titleTextField.text!.isEmpty {
//                self.saveButton.isEnabled = true
//            } else {
//                self.saveButton.isEnabled = false
//                }
//            }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)

        if newText.count == 0 {
            self.saveButton.isEnabled = false
            } else {
            self.saveButton.isEnabled = true
            }
        return true
    }

}
