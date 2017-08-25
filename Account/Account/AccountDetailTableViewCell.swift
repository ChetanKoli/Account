//
//  AccountDetailTableViewCell.swift
//  Account
//
//  Created by Chetan Koli on 8/23/17.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

class AccountDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var accountNumberLabel: UILabel!
    @IBOutlet var accountNameLabel: UILabel!
    @IBOutlet var accountBalanceLabel: UILabel!
    @IBOutlet var ibanNumberLabel: UILabel!
    @IBOutlet var accountTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
