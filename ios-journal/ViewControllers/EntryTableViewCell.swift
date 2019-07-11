//
//  EntryTableViewCell.swift
//  ios-journal
//
//  Created by Dongwoo Pae on 7/10/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodytextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    

    func updateViews() {
        guard let entry = entry else {return}
            self.titleLabel.text = entry.title
            self.bodytextLabel.text = entry.bodyText
        
            let df = DateFormatter()
            df.dateStyle = .short
            df.timeStyle = .short
            self.timeLabel.text = df.string(from: entry.timestamp!)
    }
}
