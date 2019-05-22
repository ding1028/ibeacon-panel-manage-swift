//
//  PanelTableViewCell.swift
//  IntercomKeypadLockClient
//
//  Created by my on 5/22/19.
//  Copyright © 2019 newlinks. All rights reserved.
//

import UIKit

class PanelTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var actionOpenDoor: (() -> Void)? = nil
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func openDoor(_ sender: Any) {
        if let doorOpen = actionOpenDoor {
            doorOpen();
        }
    }
    
}
