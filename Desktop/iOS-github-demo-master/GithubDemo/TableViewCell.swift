//
//  TableViewCell.swift
//  GithubDemo
//
//  Created by New on 2/2/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var avatar: UIImageView!
    @IBOutlet var textField: UITextView!
    @IBOutlet var forks: UILabel!
    @IBOutlet var stars: UILabel!
    @IBOutlet var author: UILabel!
    @IBOutlet var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
