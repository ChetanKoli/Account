//
//  AccountDetailsTodayExtensionTableViewCell.swift
//  Account
//
//  Created by Chetan on 25/08/17.
//  Copyright © 2017 tcs. All rights reserved.
//

import UIKit

class AccountDetailsTodayExtensionTableViewCell: UITableViewCell {
    
    @IBOutlet var accountNameLabel: UILabel!
    @IBOutlet var accountBalanceLabel: UILabel!
    @IBOutlet var ibanNumberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
