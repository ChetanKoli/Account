//
//  SavingAccount.swift
//  Account
//
//  Created by Chetan Koli on 8/23/17.
//  Copyright © 2017 TCS. All rights reserved.
//

import Foundation

class SavingAccount: Account
{
    var linkedAccountID: Int = 0
    var productName: String?
    var productType: Int = 0
    var savingsTargetReached: Int = 0
    var targetAmountInCents: Float = 0.0
    
    
    init(accountId: Int, accountNumber: String, iban: String, isVisible: Bool) {
        
        super.init(accountId: accountId, accountNumber: accountNumber, iban: iban, accountType: .Saving, isVisible: isVisible)
    }
    
}
